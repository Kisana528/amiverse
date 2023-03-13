import Head from "next/head"

export default function DefaultHead({ children,
  title,
  author = "KISANA",
  description = "Amiverse",
  keywords = "amiverse",
  robots = "index, follow",
  url = "/",
  type = "website",
  image = "/images/testimg.png",
  card = "summary_large_image",
  site = "amiverse.net",
  id = "amiverse.net",
  alt = "amiverse",
}) {
  return (
    <Head key={title}>
      <meta charSet="UTF-8" />
      <title>{title ? title + ' | Amiverse' : 'Amiverse'}</title>
      <meta name="theme-color" content="#ffa9c7" />
      <meta name="color-scheme" content="light" /> {/* dark対応予定 */}
      <meta name="viewport" content="width=device-width" />
      <meta name="author" content={author} />
      <meta name="generator" content="Next.js" />
      <meta name="description" content={description} />
      <meta name="keywords" content={keywords} />
      <meta name="robots" content={robots} />
      <meta name="referrer" content="no-referrer" />
      <meta name="creator" content={author} />
      <meta name="googlebot" content={robots} />
      <meta name="publisher" content={author} />
      <meta name="format-detection" content="email=no,telephone=no,address=no" />
      <meta property="og:url" content={url} />
      <meta property="og:title" content={title} />
      <meta property="og:type" content={type} />
      <meta property="og:description" content={description} />
      <meta property="og:image" content={image} />
      <meta property="og:locale" content="ja_JP" />
      <meta property="og:site_name" content={site} />
      <meta name="twitter:card" content={card} />
      <meta name="twitter:site" content={site} />
      <meta name="twitter:site:id" content={id} />
      <meta name="twitter:title" content={title} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={image} />
      <meta name="twitter:image:alt" content={alt} />
      <meta name="twitter:creator" content={author} />
      <meta name="twitter:creator:id" content={id} />
      <link rel="icon" href="/dub.ico" />
      {children}
    </Head>
  )
}