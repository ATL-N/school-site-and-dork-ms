"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { Sun, Moon, Menu, X, ExternalLink } from "lucide-react";
import { usePathname } from "next/navigation";
import Image from "next/image";

export default function Navbar() {
  const [isDark, setIsDark] = useState(false);
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const pathname = usePathname();

  useEffect(() => {
    const theme = localStorage.getItem("theme") || "light";
    setIsDark(theme === "dark");
    document.documentElement.setAttribute("data-theme", theme);
  }, []);

  const toggleTheme = () => {
    const newTheme = isDark ? "light" : "dark";
    setIsDark(!isDark);
    localStorage.setItem("theme", newTheme);
    document.documentElement.setAttribute("data-theme", newTheme);
  };

  const isActive = (path) => {
    if (path === "/" && pathname === "/") return true;
    if (path !== "/" && pathname.startsWith(path)) return true;
    return false;
  };

  const linkStyles = (path) => {
    const baseStyles =
      "px-3 py-2 rounded-md text-sm font-medium transition-all duration-200";
    const hoverStyles = "hover:bg-opacity-10 hover:bg-primary hover:scale-105";
    const activeStyles = isActive(path)
      ? "bg-primary bg-opacity-10 font-semibold border-b-2"
      : "";

    return `${baseStyles} ${hoverStyles} ${activeStyles}`.trim();
  };

  const mobileLinkStyles = (path) => {
    const baseStyles =
      "block px-3 py-2 rounded-md text-base font-medium transition-all duration-200";
    const hoverStyles = "hover:bg-opacity-10 hover:bg-primary";
    const activeStyles = isActive(path)
      ? "bg-primary bg-opacity-10 font-semibold border-l-4"
      : "";

    return `${baseStyles} ${hoverStyles} ${activeStyles}`.trim();
  };

  return (
    <nav
      className="fixed w-full z-50 bg-opacity-90 backdrop-blur-sm shadow-lg"
      style={{ backgroundColor: "var(--background-color)" }}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center space-x-2">
            <Image
              src="/favicon.ico"
              alt="Cyan Academy Logo"
              width={32}
              height={32}
              className="hover:rotate-12 transition-transform duration-300"
            />
            <Link
              href="/"
              className="text-2xl font-bold hover:opacity-80 transition-opacity duration-200"
              style={{ color: "var(--primary-color)" }}
            >
              {process.env.NEXT_PUBLIC_SCHOOL_NAME_SHORT || "You School Name"}
            </Link>
          </div>

          {/* Desktop Menu */}
          <div className="hidden md:block">
            <div className="ml-10 flex items-center space-x-4">
              <Link
                href="/"
                className={linkStyles("/")}
                style={{ borderColor: "var(--primary-color)" }}
              >
                Home
              </Link>
              <Link
                href="/webpages/about"
                className={linkStyles("/webpages/about")}
                style={{ borderColor: "var(--primary-color)" }}
              >
                About
              </Link>
              <Link
                href="/webpages/academics"
                className={linkStyles("/webpages/academics")}
                style={{ borderColor: "var(--primary-color)" }}
              >
                Academics
              </Link>
              <Link
                href="/webpages/admissions"
                className={linkStyles("/webpages/admissions")}
                style={{ borderColor: "var(--primary-color)" }}
              >
                Admissions
              </Link>
              <Link
                href="/webpages/facilities"
                className={linkStyles("/webpages/facilities")}
                style={{ borderColor: "var(--primary-color)" }}
              >
                Facilities
              </Link>
              <Link
                href="/webpages/contact"
                className={linkStyles("/webpages/contact")}
                style={{ borderColor: "var(--primary-color)" }}
              >
                Contact
              </Link>

              {/* External Link Button */}
              <a
                href="https://dorkmspreview.dorkordi.site/authentication/login" //"/pages" // Replace with actual portal URL
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center px-4 py-2 rounded-full text-white transition-all duration-200 hover:opacity-90 hover:scale-105"
                style={{ backgroundColor: "var(--primary-color)" }}
              >
                Portal <ExternalLink className="ml-1" size={16} />
              </a>

              <button
                onClick={toggleTheme}
                className="p-2 rounded-full hover:bg-opacity-20 hover:bg-gray-600 transition-colors duration-200"
                style={{ color: "var(--primary-color)" }}
              >
                {isDark ? <Sun size={20} /> : <Moon size={20} />}
              </button>
            </div>
          </div>

          {/* Mobile menu button */}
          <div className="md:hidden">
            <button
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              className="p-2 rounded-md hover:bg-opacity-20 hover:bg-gray-600 transition-colors duration-200"
              style={{ color: "var(--primary-color)" }}
            >
              {isMenuOpen ? <X size={24} /> : <Menu size={24} />}
            </button>
          </div>
        </div>

        {/* Mobile menu */}
        {isMenuOpen && (
          <div className="md:hidden animated-element">
            <div className="px-2 pt-2 pb-3 space-y-1 sm:px-3">
              <Link
                href="/"
                className={mobileLinkStyles("/")}
                style={{ borderColor: "var(--primary-color)" }}
              >
                Home
              </Link>
              <Link
                href="/webpages/about"
                className={mobileLinkStyles("/webpages/about")}
                style={{ borderColor: "var(--primary-color)" }}
              >
                About
              </Link>
              <Link
                href="/webpages/academics"
                className={mobileLinkStyles("/webpages/academics")}
                style={{ borderColor: "var(--primary-color)" }}
              >
                Academics
              </Link>
              <Link
                href="/webpages/admissions"
                className={mobileLinkStyles("/webpages/admissions")}
                style={{ borderColor: "var(--primary-color)" }}
              >
                Admissions
              </Link>
              <Link
                href="/webpages/facilities"
                className={mobileLinkStyles("/webpages/facilities")}
                style={{ borderColor: "var(--primary-color)" }}
              >
                Facilities
              </Link>
              <Link
                href="/webpages/contact"
                className={mobileLinkStyles("/webpages/contact")}
                style={{ borderColor: "var(--primary-color)" }}
              >
                Contact
              </Link>

              {/* External Link in Mobile Menu */}
              <a
                href="/pages" // Replace with actual portal URL
                target="_blank"
                rel="noopener noreferrer"
                className="block px-3 py-2 rounded-md text-base font-medium transition-all duration-200 text-white"
                style={{ backgroundColor: "var(--primary-color)" }}
              >
                <span className="flex items-center">
                  Portal <ExternalLink className="ml-1" size={16} />
                </span>
              </a>
            </div>
          </div>
        )}
      </div>
    </nav>
  );
}
