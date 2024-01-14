import * as React from "react"
import { Chip } from "@mui/material"
import { skills } from "../constants/constants"

const Skills = () => {
  return (
    <div className="skills">
      <h2>Skills</h2>
      {skills.map(skill => {
        return <Chip label={skill} color="primary" key={skill} />
      })}
    </div>
  )
}
export default Skills
