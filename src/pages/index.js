import * as React from "react"
import { graphql } from "gatsby"
import Bio from "../components/bio"
import Layout from "../components/layout"
import Seo from "../components/seo"
import Skills from "../components/skills"
import Education from "../components/education"
import Social from "../components/social"
import Contact from "../components/contact"
import Resume from "../components/resume"
import Expandable from "../components/expandable"

const HomePage = ({ data, location }) => {
  const siteTitle = data.site.siteMetadata.title
  const posts = data.allMarkdownRemark.nodes

  if (posts.length === 0) {
    return (
      <Layout location={location} title={siteTitle}>
        <Bio />
        <p>
          No blog posts found. Add markdown posts to "content/blog" (or the
          directory you specified for the "gatsby-source-filesystem" plugin in
          gatsby-config.js.
        </p>
      </Layout>
    )
  }

  return (
    <Layout location={location} title={siteTitle}>
      <Bio />
      <Expandable id="education" title="Education" content={<Education />} />
      <Expandable id="skills" title="Skills" content={<Skills />} />
      <Expandable id="social" title="Social" content={<Social />} />
      <Expandable
        id="resume"
        title="Resume"
        content={<Resume posts={posts} />}
      />
      <Expandable id="contact" title="Contact" content={<Contact />} />
    </Layout>
  )
}

export default HomePage

/**
 * Head export to define metadata for the page
 *
 * See: https://www.gatsbyjs.com/docs/reference/built-in-components/gatsby-head/
 */
export const Head = () => <Seo title="Home" />

export const pageQuery = graphql`
  {
    site {
      siteMetadata {
        title
      }
    }
    allMarkdownRemark(sort: { frontmatter: { start: DESC } }) {
      nodes {
        excerpt
        fields {
          slug
        }
        frontmatter {
          start(formatString: "MMMM, YYYY")
          end(formatString: "MMMM, YYYY")
          title
          description
        }
      }
    }
  }
`
