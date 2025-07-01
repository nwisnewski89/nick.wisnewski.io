import * as React from "react"
import { useState } from "react"
import {
  TextField,
  Button,
  Box,
  Alert,
  Snackbar,
  Paper,
  Typography,
  Stack,
} from "@mui/material"
import { API_URL, API_KEY } from "../constants/constants"

const Contact = () => {
  const [formData, setFormData] = useState({
    from_address: "",
    message: "",
  })
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [snackbar, setSnackbar] = useState({
    open: false,
    message: "",
    severity: "success",
  })

  const handleInputChange = e => {
    const { name, value } = e.target
    setFormData(prev => ({
      ...prev,
      [name]: value,
    }))
  }

  const handleSubmit = async e => {
    e.preventDefault()
    setIsSubmitting(true)

    try {
      const headers = API_URL.includes("localhost")
        ? {
            "Content-Type": "application/json",
            Authorization: `Bearer ${API_KEY}`,
          }
        : {
            "Content-Type": "application/json",
          }

      const response = await fetch(`${API_URL}/contact`, {
        method: "POST",
        headers,
        body: JSON.stringify(formData),
      })

      if (response.ok) {
        setSnackbar({
          open: true,
          message: "Message sent successfully!",
          severity: "success",
        })
        setFormData({
          from_address: "",
          message: "",
        })
      } else {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
    } catch (error) {
      console.error("Error sending message:", error)
      setSnackbar({
        open: true,
        message: "Failed to send message. Please try again.",
        severity: "error",
      })
    } finally {
      setIsSubmitting(false)
    }
  }

  const handleCancel = () => {
    setFormData({
      from_address: "",
      message: "",
    })
  }

  const handleCloseSnackbar = () => {
    setSnackbar(prev => ({
      ...prev,
      open: false,
    }))
  }

  return (
    <Box className="contact-form" sx={{ maxWidth: 600, mx: "auto", p: 2 }}>
      <Paper elevation={3} sx={{ p: 4 }}>
        <Typography variant="h4" component="h2" gutterBottom>
          Contact Me
        </Typography>

        <Box component="form" onSubmit={handleSubmit} sx={{ mt: 3 }}>
          <Stack spacing={3}>
            <TextField
              required
              fullWidth
              label="Email Address"
              name="from_address"
              type="email"
              value={formData.from_address}
              onChange={handleInputChange}
              placeholder="your.email@example.com"
              variant="outlined"
            />

            <TextField
              required
              fullWidth
              label="Message"
              name="message"
              multiline
              rows={6}
              value={formData.message}
              onChange={handleInputChange}
              placeholder="Enter your message here..."
              variant="outlined"
            />

            <Box sx={{ display: "flex", gap: 2, justifyContent: "flex-end" }}>
              <Button
                variant="outlined"
                onClick={handleCancel}
                disabled={isSubmitting}
                sx={{ minWidth: 100 }}
              >
                Cancel
              </Button>
              <Button
                type="submit"
                variant="contained"
                disabled={
                  isSubmitting || !formData.from_address || !formData.message
                }
                sx={{ minWidth: 100 }}
              >
                {isSubmitting ? "Sending..." : "Send Message"}
              </Button>
            </Box>
          </Stack>
        </Box>
      </Paper>

      <Snackbar
        open={snackbar.open}
        autoHideDuration={6000}
        onClose={handleCloseSnackbar}
        anchorOrigin={{ vertical: "top", horizontal: "center" }}
      >
        <Alert
          onClose={handleCloseSnackbar}
          severity={snackbar.severity}
          sx={{ width: "100%" }}
        >
          {snackbar.message}
        </Alert>
      </Snackbar>
    </Box>
  )
}

export default Contact
