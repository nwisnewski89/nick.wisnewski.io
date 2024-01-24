import * as React from "react"
import { useStaticQuery, graphql } from "gatsby"
import { StaticImage } from "gatsby-plugin-image"

const Bio = () => {
  const data = useStaticQuery(graphql`
    query BioQuery {
      site {
        siteMetadata {
          author {
            summary
          }
          social {
            linkedin
          }
        }
      }
    }
  `)

  const author = data.site.siteMetadata?.author

  return (
    <div className="bio">
      <StaticImage
        className="bio-avatar"
        layout="fixed"
        formats={["auto", "webp", "avif"]}
        src="../images/profile-pic.png"
        width={50}
        height={100}
        quality={100}
        alt="Profile picture"
      />
      <p>
        {author?.summary || null}
        {` `}
        <br />
        <br />
        Located in <b>Philadelphia, PA</b>.
      </p>
    </div>
  )
}

export default Bio
