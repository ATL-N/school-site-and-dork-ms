import { getAllRoutes } from "../lib/routes"; // You'll need to create this

const generateSitemap = (routes) => {
  return `<?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
      ${routes
        .map((route) => {
          return `
            <url>
              <loc>https://dorkordi.site${route}</loc>
              <lastmod>${new Date().toISOString()}</lastmod>
              <changefreq>daily</changefreq>
              <priority>0.7</priority>
            </url>
          `;
        })
        .join("")}
    </urlset>
  `;
};

export async function getServerSideProps({ res }) {
  const routes = getAllRoutes(); // Implement this function to get all your routes
  const sitemap = generateSitemap(routes);

  res.setHeader("Content-Type", "text/xml");
  res.write(sitemap);
  res.end();

  return {
    props: {},
  };
}

export default function Sitemap() {
  return null;
}
