import * as React from "react"
import { GatsbyImage, getImage } from "gatsby-plugin-image"
import { useStaticQuery, graphql } from "gatsby"
import { SOCIAL } from "../constants/constants"

const Social = () => {
  const data = useStaticQuery(graphql`
    query {
      linkedinLogo: file(relativePath: { eq: "LI-In-Bug.png" }) {
        childImageSharp {
          gatsbyImageData(
            width: 30
            height: 30
            quality: 100
            formats: [AUTO, WEBP, AVIF]
          )
        }
      }
      githubLogo: file(relativePath: { eq: "github-mark.png" }) {
        childImageSharp {
          gatsbyImageData(
            width: 30
            height: 30
            quality: 100
            formats: [AUTO, WEBP, AVIF]
          )
        }
      }
    }
  `)

  const imageMap = {
    linkedin: getImage(data.linkedinLogo),
    github: getImage(data.githubLogo),
  }

  return (
    <div className="social">
      {Object.entries(SOCIAL).map(([key, value]) => (
        <div key={key} className={key + "-link"}>
          <GatsbyImage className={key} image={imageMap[key]} alt={value.alt} />
          <a href={value.link} target="_blank" rel="noreferrer">
            {value.text}
          </a>
        </div>
      ))}
    </div>
  )
}

export default Social
