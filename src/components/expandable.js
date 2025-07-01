import * as React from "react"
import { Accordion, AccordionSummary, AccordionDetails } from "@mui/material"

const Expandable = ({ id, title, content }) => {
  return (
    <Accordion>
      <AccordionSummary id={id} aria-controls={id}>
        {title}
      </AccordionSummary>
      <AccordionDetails>{content}</AccordionDetails>
    </Accordion>
  )
}

export default Expandable
