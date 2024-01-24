import React from "react"
import Accordion from "@mui/material/Accordion"
import AccordionDetails from "@mui/material/AccordionDetails"
import AccordionSummary from "@mui/material/AccordionSummary"
import Typography from "@mui/material/Typography"
import ExpandMoreIcon from "@mui/icons-material/ExpandMore"
import { Button } from "@mui/material"
import Box from "@mui/material/Box"
import SendIcon from "@mui/icons-material/Send"

const functionURL = "" // replace this with your function URL

class ContactForm extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      buttonDisabled: true,
      message: { fromEmail: "", subject: "", body: "" },
      submitting: false,
      error: null,
    }
  }

  onClick = async event => {
    event.preventDefault()
    this.setState({ submitting: true })
    const { fromEmail, subject, body } = this.state.message

    const response = await fetch(functionURL, {
      method: "post",
      headers: {
        "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
      },
      body: new URLSearchParams({ fromEmail, subject, body }).toString(),
    })
    if (response.status === 200) {
      this.setState({
        error: null,
        submitting: false,
        message: {
          fromEmail: "",
          subject: "",
          body: "",
        },
      })
    } else {
      const json = await response.json()
      this.setState({
        error: json.error,
        submitting: false,
      })
    }
  }

  onChange = event => {
    const name = event.target.getAttribute("name")
    this.setState({
      message: { ...this.state.message, [name]: event.target.value },
    })
  }
  render() {
    return (
      <Accordion>
        <AccordionSummary
          expandIcon={<ExpandMoreIcon />}
          id="contact-header"
          aria-controls="contact-me"
        >
          <div className="contact-form">
            <Typography sx={{ width: "100%", flexShrink: 0 }}>
              <b>Contact Me</b>
            </Typography>
          </div>
        </AccordionSummary>
        <AccordionDetails>
          <>
            <div>{this.state.error}</div>
            <Box
              component="form"
              sx={{
                "& .MuiTextField-root": { m: 1, width: "25ch" },
              }}
              noValidate
              autoComplete="off"
            >
              <form
                style={{
                  display: `flex`,
                  flexDirection: `column`,
                  maxWidth: `500px`,
                }}
                method="post"
                action={functionURL}
              >
                <label htmlFor="fromEmail">Your email address:</label>
                <input
                  type="email"
                  name="fromEmail"
                  id="fromEmail"
                  value={this.state.message.fromEmail}
                  onChange={this.onChange}
                ></input>
                <label htmlFor="subject">Subject:</label>
                <input
                  type="text"
                  name="subject"
                  id="subject"
                  value={this.state.message.subject}
                  onChange={this.onChange}
                />
                <label htmlFor="body">Message:</label>
                <textarea
                  style={{
                    height: `125px`,
                  }}
                  name="body"
                  id="body"
                  value={this.state.message.body}
                  onChange={this.onChange}
                />
                <Button
                  endIcon={<SendIcon />}
                  variant="contained"
                  disabled={this.state.submitting}
                  onClick={this.onClick}
                >
                  Send message
                </Button>
              </form>
            </Box>
          </>
        </AccordionDetails>
      </Accordion>
    )
  }
}

export default ContactForm
