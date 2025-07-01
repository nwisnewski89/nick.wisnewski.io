from fastapi import FastAPI, HTTPException, Depends, status, Request
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.middleware.cors import CORSMiddleware
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
import boto3
import os
import logging
from datetime import datetime, timedelta
from typing import Optional
import json
from pydantic import BaseModel, EmailStr, validator

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI with rate limiting
limiter = Limiter(key_func=get_remote_address)
app = FastAPI(
    title="Small Email Service",
    description="A small email service for sending emails to a single recipient",
    version="1.0.0"
)

# Add rate limiting middleware
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=os.getenv("ALLOWED_ORIGINS", "http://localhost:3000").split(","),
    allow_credentials=True,
    allow_methods=["POST"],
    allow_headers=["*"],
)

# Security
security = HTTPBearer()

# Pydantic models
class EmailRequest(BaseModel):
    message: str
    from_address: str
    
    @validator('message')
    def validate_message(cls, v):
        if len(v.strip()) == 0:
            raise ValueError('Message cannot be empty')
        if len(v) > 10000:
            raise ValueError('Message too long (max 10,000 characters)')
        return v.strip()
    
    @validator('from_address')
    def validate_from_address(cls, v):
        if v:
            v = v.strip()
            # Basic email validation - just check for @ symbol
            if '@' not in v or '.' not in v:
                raise ValueError('Invalid email format')
        return v if v else None

class EmailResponse(BaseModel):
    message_id: str
    status: str
    timestamp: datetime

class SESService:
    def __init__(self):
        self.ses = boto3.client(
            'ses',
            region_name=os.getenv('AWS_REGION', 'us-east-1'),
            aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
            aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY')
        )
        
    def send_email(self, subject: str, message: str) -> str:
        """Send email via AWS SES"""
        try:
            verified_domain = os.getenv('DOMAIN')
            if not verified_domain:
                raise ValueError("VDOMAIN environment variable must be set")
            
            sender = f"no-reply@{verified_domain}"
        
            response = self.ses.send_email(
                Source=sender,
                Destination={
                    'ToAddresses': [os.getenv('TO_EMAIL')]
                },
                Message={
                    'Subject': {
                        'Data': subject,
                        'Charset': 'UTF-8'
                    },
                    'Body': {
                        'Text': {
                            'Data': message,
                            'Charset': 'UTF-8'
                        }
                    }
                }
            )
            
            logger.info(f"Email sent successfully: {response['MessageId']}")
            return response['MessageId']
            
        except Exception as e:
            logger.error(f"Failed to send email: {str(e)}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to send email"
            )

# Initialize SES service
ses_service = SESService()

# API Key validation
def validate_api_key(credentials: HTTPAuthorizationCredentials = Depends(security)) -> bool:
    """Validate API key from Authorization header"""
    api_key = os.getenv('API_KEY')
    if not api_key:
        logger.error("API_KEY not configured in environment")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Server configuration error"
        )
    
    if credentials.credentials != api_key:
        logger.warning(f"Invalid API key attempt from {get_remote_address()}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid API key"
        )
    
    return True

# Rate limiting dependency
def rate_limit_check():
    """Check rate limits for the current request"""
    # This will be handled by the slowapi middleware
    pass

# Rate limiting decorators
@app.post("/contact", response_model=EmailResponse)
@limiter.limit("1/minute")  
@limiter.limit("10/hour")   
async def contact(
    request: Request,
    email_request: EmailRequest,
    credentials: HTTPAuthorizationCredentials = Depends(security)
):
    """
    Send an email via AWS SES
    
    - **subject**: Email subject (max 200 characters)
    - **message**: Email message content (max 10,000 characters)
    - **from_email**: Optional sender email (must be Gmail, Outlook, or Yahoo)
    """
    # Validate API key
    validate_api_key(credentials) 

    # Check for suspicious content
    suspicious_keywords = ['password', 'credit card', 'ssn', 'social security']
    message_lower = email_request.message.lower()
    if any(keyword in message_lower for keyword in suspicious_keywords):
        logger.warning(f"Suspicious content detected in email from {get_remote_address()}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email content contains restricted keywords"
        )
    
    try:
        # Send email
        message_id = ses_service.send_email(
            subject=f"Contact from {email_request.from_address}",
            message=email_request.message
        )
        
        return EmailResponse(
            message_id=message_id,
            status="sent",
            timestamp=datetime.utcnow()
        )
        
    except Exception as e:
        logger.error(f"Error sending email: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to send email"
        )

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "timestamp": datetime.utcnow()}

@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "message": "Email Service API",
        "version": "1.0.0",
        "endpoints": {
            "contact": "/contact",
            "health": "/health",
            "docs": "/docs"
        }
    }

if __name__ == "__main__":  
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)