import * as React from "react"
import { StaticImage } from "gatsby-plugin-image"

const Education = () => {
  return (
    <div className="education">
      <h2>Education</h2>
      <StaticImage
        className="drexel-logo"
        src="../images/drexel-logo.png"
        alt="drexel university"
        width={50}
        hight={50}
      />
      <p>
        <br />
        <b>Drexel University</b>
        <br />
        Bachelor of Science in Mathematics
        <br />
        Graduated Summer 2015, GPA 3.29
      </p>
    </div>
  )
}

export default Education
