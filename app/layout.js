import { Providers } from "./providers";
import SessionRefresh from "./components/SessionRefresh";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "School Management System",
  description: "Generated by create next app",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Providers>
          <SessionRefresh /> {children}
        </Providers>
      </body>
    </html>
  );
}
