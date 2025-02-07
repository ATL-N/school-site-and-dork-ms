"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import {
  ArrowRight,
  Book,
  Users,
  Trophy,
  Calendar,
  ChevronDown,
  ChevronUp,
} from "lucide-react";

const NewsCard = ({ news }) => {
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const [expanded, setExpanded] = useState(false);

  useEffect(() => {
    // Set up an interval to automatically cycle images every 3 seconds
    const imageInterval = setInterval(() => {
      setCurrentImageIndex((prev) => (prev + 1) % news.images.length);
    }, 3000);

    // Clear the interval when the component unmounts
    return () => clearInterval(imageInterval);
  }, [news.images.length]);

  const nextImage = () => {
    setCurrentImageIndex((prev) => (prev + 1) % news.images.length);
  };

  return (
    <div
      className="rounded-lg overflow-hidden hover-scale animated-element relative"
      style={{ backgroundColor: "var(--accent-color)" }}
    >
      <div className="relative">
        <img
          src={news.images[currentImageIndex]}
          alt={news.title}
          className="w-full h-48 object-cover transition-all duration-500 ease-in-out"
          onClick={nextImage}
        />
        <div
          className="absolute top-2 right-2 rounded-full p-1 cursor-pointer"
          onClick={nextImage}
        >
          <ChevronDown size={16} />
        </div>
      </div>
      <div className="p-6">
        <h3 className="text-xl font-semibold mb-2">{news.title}</h3>
        <p className="mb-4">{expanded ? news.fullContent : news.description}</p>
        <div className="flex justify-between items-center">
          <button
            onClick={() => setExpanded(!expanded)}
            className="text-sm flex items-center"
            style={{ color: "var(--primary-color)" }}
          >
            {expanded ? "Show Less" : "Expand"}
            {expanded ? (
              <ChevronUp className="ml-1" size={16} />
            ) : (
              <ChevronDown className="ml-1" size={16} />
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

export default NewsCard;
