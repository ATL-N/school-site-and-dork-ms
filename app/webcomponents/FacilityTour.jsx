"use client";

import { useState, useEffect, useRef } from "react";
import { ChevronLeft, ChevronRight, Maximize } from "lucide-react";

const facilities = [
  {
    id: 1,
    name: "Modern Classrooms",
    description:
      "State-of-the-art classrooms equipped with smart boards and multimedia facilities",
    imageUrl: "/images/facilities/basicschoolghana-newsfinal.jpg",
    features: [
      "Interactive Whiteboards",
      "Ergonomic Furniture",
      "Natural Lighting",
      "Climate Control",
    ],
  },
  {
    id: 2,
    name: "Science Laboratories",
    description:
      "Fully equipped laboratories for physics, chemistry, and biology experiments",
    imageUrl: "/images/facilities/images.jpeg",
    features: [
      "Safety Equipment",
      "Modern Apparatus",
      "Research Facilities",
      "Digital Microscopes",
    ],
  },
  {
    id: 3,
    name: "Sports Complex",
    description:
      "Comprehensive sports facilities for various indoor and outdoor activities",
    imageUrl: "/images/facilities/time_with_ubas_12.jpg",
    features: [
      "Indoor Gymnasium",
      "Swimming Pool",
      "Basketball Courts",
      "Football Field",
    ],
  },
  {
    id: 4,
    name: "Library",
    description:
      "Extensive collection of books, digital resources, and study areas",
    imageUrl:
      "/images/facilities/5fd5eb47-518b-408a-8fcc-bd5befded7b5-1024x663.jpeg",
    features: [
      "Digital Catalogs",
      "Study Rooms",
      "Online Resources",
      "Reading Areas",
    ],
  },
];

export default function FacilityTour() {
  const [currentFacility, setCurrentFacility] = useState(0);
  const [isFullscreen, setIsFullscreen] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [fadeIn, setFadeIn] = useState(true);
  const autoSlideTimer = useRef(null);
  const SLIDE_INTERVAL = 5000; // 5 seconds

  const nextFacility = () => {
    setFadeIn(false);
    setTimeout(() => {
      setCurrentFacility((prev) => (prev + 1) % facilities.length);
      setFadeIn(true);
    }, 300); // Match this with CSS transition duration
  };

  const prevFacility = () => {
    setFadeIn(false);
    setTimeout(() => {
      setCurrentFacility(
        (prev) => (prev - 1 + facilities.length) % facilities.length
      );
      setFadeIn(true);
    }, 300);
  };

  const toggleFullscreen = () => {
    if (!isFullscreen) {
      const element = document.documentElement;
      if (element.requestFullscreen) {
        element.requestFullscreen();
      }
    } else {
      if (document.exitFullscreen) {
        document.exitFullscreen();
      }
    }
    setIsFullscreen(!isFullscreen);
  };

  // Auto-slide functionality
  useEffect(() => {
    const startAutoSlide = () => {
      if (!isHovered) {
        autoSlideTimer.current = setInterval(nextFacility, SLIDE_INTERVAL);
      }
    };

    const stopAutoSlide = () => {
      if (autoSlideTimer.current) {
        clearInterval(autoSlideTimer.current);
      }
    };

    startAutoSlide();

    return () => stopAutoSlide();
  }, [isHovered]);

  const facility = facilities[currentFacility];

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-4 lg:px-4 py-4">
      <h2
        className="text-3xl font-bold text-center mb-4"
        style={{ color: "var(--primary-color)" }}
      >
        Campus Facilities Tour
      </h2>

      <div
        className="relative bg-white rounded-lg shadow-lg overflow-hidden animated-element"
        onMouseEnter={() => setIsHovered(true)}
        onMouseLeave={() => setIsHovered(false)}
      >
        {/* Image Section */}
        <div className="relative h-96">
          <img
            src={facility.imageUrl}
            alt={facility.name}
            className={`w-full h-full object-cover transition-opacity duration-300 ${
              fadeIn ? "opacity-100" : "opacity-0"
            }`}
          />

          {/* Navigation Buttons */}
          <div className="absolute inset-0 flex items-center justify-between p-4">
            <button
              onClick={prevFacility}
              className="p-2 rounded-full bg-white/80 hover:bg-white transition shadow-lg"
              style={{ color: "var(--primary-color)" }}
            >
              <ChevronLeft size={24} />
            </button>
            <button
              onClick={nextFacility}
              className="p-2 rounded-full bg-white/80 hover:bg-white transition shadow-lg"
              style={{ color: "var(--primary-color)" }}
            >
              <ChevronRight size={24} />
            </button>
          </div>

          {/* Fullscreen Button */}
          <button
            onClick={toggleFullscreen}
            className="absolute top-4 right-4 p-2 rounded-full bg-white/80 hover:bg-white transition shadow-lg"
            style={{ color: "var(--primary-color)" }}
          >
            <Maximize size={24} />
          </button>
        </div>

        {/* Content Section */}
        <div
          className={`p-6 transition-opacity duration-300 ${
            fadeIn ? "opacity-100" : "opacity-0"
          }`}
        >
          <h3
            className="text-2xl font-semibold mb-2"
            style={{ color: "var(--primary-color)" }}
          >
            {facility.name}
          </h3>
          <p className="text-gray-600 mb-4">{facility.description}</p>

          {/* Features Grid */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {facility.features.map((feature, index) => (
              <div
                key={index}
                className="p-3 rounded-lg text-center hover-scale"
                style={{ backgroundColor: "var(--accent-color)" }}
              >
                <span className="text-sm font-medium">{feature}</span>
              </div>
            ))}
          </div>

          {/* Progress Indicators */}
          <div className="flex justify-center mt-6 space-x-2">
            {facilities.map((_, index) => (
              <div
                key={index}
                className="w-2 h-2 rounded-full transition-colors"
                style={{
                  backgroundColor:
                    index === currentFacility
                      ? "var(--primary-color)"
                      : "var(--accent-color)",
                }}
              />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
