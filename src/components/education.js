import * as React from "react"
import { StaticImage } from "gatsby-plugin-image"

const Education = () => {
  return (
    <>
      <h2>Education</h2>
      <div className="education">
        <StaticImage
          className="education-logo"
          formats={["auto", "webp", "avif"]}
          src="../images/drexel-logo.png"
          alt="Drexel University"
          layout="fixed"
          width={100}
          height={100}
          quality={95}
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
    </>
  )
}

export default Education
