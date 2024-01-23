import * as React from "react"
import { StaticImage } from "gatsby-plugin-image"

const Social = () => {
  return (
    <div className="social">
      <div className="linkedin">
        <StaticImage
          className="linkedin-logo"
          src="../images/linkedin-logo.png"
          alt="linkedin"
          width={30}
          hight={30}
        />
        <a
          href="https://www.linkedin.com/in/nick-f-wisnewski"
          target="_blank"
          rel="noreferrer"
        >
          Add me on Linkedin
        </a>
      </div>
      <div className="github">
        <StaticImage
          className="github-logo"
          src="../images/github-logo.png"
          alt="github"
          width={30}
          hight={30}
        />
        <a
          href="https://github.com/nwisnewski89/nick.wisnewski.io"
          target="_blank"
          rel="noreferrer"
        >
          How I Built This
        </a>
      </div>
    </div>
  )
}

export default Social
