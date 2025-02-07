import Head from "next/head";

export default function Layout({ children, title, description }) {
  const siteTitle = title ? `${title} | Your Site Name` : "Your Site Name";
  const siteDescription = description || "Default description of your site";

  return (
    <>
      <Head>
        <title>{siteTitle}</title>
        <meta name="description" content={siteDescription} />
        <meta name="viewport" content="width=device-width, initial-scale=1" />

        {/* Open Graph / Social Media Meta Tags */}
        <meta property="og:type" content="website" />
        <meta property="og:title" content={siteTitle} />
        <meta property="og:description" content={siteDescription} />
        <meta property="og:url" content="https://dorkordi.site" />

        {/* Twitter Card */}
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content={siteTitle} />
        <meta name="twitter:description" content={siteDescription} />

        {/* Favicon */}
        <link rel="icon" href="/favicon.ico" />

        {/* Canonical URL */}
        <link rel="canonical" href="https://dorkordi.site" />
      </Head>
      <main>{children}</main>
    </>
  );
}
