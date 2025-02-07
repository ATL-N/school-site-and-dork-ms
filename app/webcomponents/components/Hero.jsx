"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { ChevronRight } from "lucide-react";

export default function Hero({
  title,
  subtitle,
  showButton = false,
  buttonText = "Learn More",
  buttonLink = "/",
  backgroundImage = null,
  size = "large", // can be 'small', 'medium', or 'large'
}) {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    setIsVisible(true);
  }, []);

  const getPaddingClass = () => {
    switch (size) {
      case "small":
        return "pt-20 pb-8";
      case "medium":
        return "pt-24 pb-12";
      default:
        return "pt-32 pb-16";
    }
  };

  return (
    <section
      className={`relative ${getPaddingClass()} px-4 sm:px-6 lg:px-8 transition-opacity duration-500 ${
        isVisible ? "opacity-100" : "opacity-0"
      }`}
      style={{
        backgroundImage: backgroundImage ? `url(${backgroundImage})` : "none",
        backgroundSize: "cover",
        backgroundPosition: "center",
      }}
    >
      {/* Overlay for background image */}
      {backgroundImage && (
        <div
          className="absolute inset-0"
          style={{ backgroundColor: "rgba(0, 0, 0, 0.5)" }}
        ></div>
      )}

      <div className="relative max-w-7xl mx-auto">
        <div className="text-center animated-element">
          <h1
            className={`${
              size === "small" ? "text-3xl sm:text-4xl" : "text-4xl sm:text-6xl"
            } font-bold mb-6`}
            style={{ color: "var(--primary-color)" }}
          >
            {title}
          </h1>

          {subtitle && (
            <p
              className={`
              ${size === "small" ? "text-lg" : "text-xl"}
              mb-8 max-w-3xl mx-auto
              ${backgroundImage ? "text-white" : ""}
            `}
            >
              {subtitle}
            </p>
          )}

          {showButton && (
            <Link
              href={buttonLink}
              className="inline-flex items-center px-6 py-3 rounded-full text-white hover-scale transition-transform duration-300"
              style={{ backgroundColor: "var(--primary-color)" }}
            >
              {buttonText}
              <ChevronRight className="ml-2" size={20} />
            </Link>
          )}
        </div>
      </div>
    </section>
  );
}
