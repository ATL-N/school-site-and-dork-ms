import { Inter } from "next/font/google";
import Navbar from "./webcomponents/Navbar"; // Import Navbar
import Footer from "./webcomponents/Footer"; // I
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "Cyan Academy - Where Future Leaders Emerge",
  description: "A modern educational institution focused on excellence",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Navbar /> {/* Render Navbar */}
        <main>{children}</main> {/* Render page content */}
        <Footer /> {/* Render Footer */}
      </body>
    </html>
  );
}
