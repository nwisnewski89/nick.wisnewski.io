import * as React from "react"
import { Link } from "gatsby"

const Resume = ({ posts }) => {
  return (
    <ol style={{ listStyle: `none` }}>
      <h2>Professional Experience</h2>
      {posts.map(post => {
        const title = post.frontmatter.title || post.fields.slug

        return (
          <li key={post.fields.slug}>
            <article
              className="post-list-item"
              itemScope
              itemType="http://schema.org/Article"
            >
              <header>
                <h2>
                  <Link to={post.fields.slug} itemProp="url">
                    <span itemProp="headline">{title}</span>
                  </Link>
                </h2>
                <small>
                  From {post.frontmatter.start} - To {post.frontmatter.end}
                </small>
              </header>
              <section>
                <p
                  dangerouslySetInnerHTML={{
                    __html: post.frontmatter.description || post.excerpt,
                  }}
                  itemProp="description"
                />
              </section>
            </article>
          </li>
        )
      })}
    </ol>
  )
}

export default Resume
