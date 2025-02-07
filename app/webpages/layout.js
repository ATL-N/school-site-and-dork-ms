import { Providers } from "./providers";
import SidePanel from "../components/sidepanel/sidepanel";
import Footer from "../webcomponents/Footer";
import Header from "../components/header/header";
import Navbar from '../webcomponents/Navbar'
import { Suspense } from "react";

export default function DashboardLayout({ children }) {
  return (
    <html>
      <body>
        {/* <Header />
        <SidePanel /> */}
        <Navbar />

        <Providers>
          <Suspense fallback={<loading />}>
              <>
                {children}
              </>
          </Suspense>
        </Providers>
        <Footer />
      </body>
    </html>
  );
}
