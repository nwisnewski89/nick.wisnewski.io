import * as React from "react"
import { styled } from "@mui/material/styles"
import Chip from "@mui/material/Chip"
import Paper from "@mui/material/Paper"
import { SKILLS } from "../constants/constants"

const Skills = () => {
  const ListItem = styled("li")(({ theme }) => ({
    margin: theme.spacing(0.5),
  }))

  return (
    <>
      <h2>Technical Skills</h2>
      <Paper
        sx={{
          display: "flex",
          justifyContent: "center",
          flexWrap: "wrap",
          listStyle: "none",
          p: 0.5,
          m: 0,
        }}
        component="ul"
      >
        {SKILLS.map(skill => {
          return (
            <ListItem key={skill.name}>
              <Chip
                component="a"
                label={skill.name}
                color="primary"
                key={skill.name}
                variant="outlined"
                href={skill.link}
                target="_blank"
                clickable
              />
            </ListItem>
          )
        })}
      </Paper>
    </>
  )
}

export default Skills
