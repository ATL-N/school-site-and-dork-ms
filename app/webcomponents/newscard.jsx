"use client";

import { useState, useEffect } from "react";
import { ChevronDown, ChevronUp } from "lucide-react";
import Image from "next/image";

const NewsCard = ({ news }) => {
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const [expanded, setExpanded] = useState(false);
  const [imageError, setImageError] = useState(false);

  useEffect(() => {
    const imageInterval = setInterval(() => {
      if (news.images.length > 1) {
        setCurrentImageIndex((prev) => (prev + 1) % news.images.length);
      }
    }, 3000);

    return () => clearInterval(imageInterval);
  }, [news.images.length]);

  const nextImage = () => {
    if (news.images.length > 1) {
      setCurrentImageIndex((prev) => (prev + 1) % news.images.length);
    }
  };

  const handleImageError = () => {
    setImageError(true);
  };

  return (
    <div
      className="rounded-lg overflow-hidden hover-scale animated-element relative"
      style={{ backgroundColor: "var(--accent-color)" }}
    >
      <div className="relative w-full h-48">
        {imageError ? (
          <div className="w-full h-full bg-gray-200 flex items-center justify-center text-gray-500">
            Image not available
          </div>
        ) : (
          <Image
            src={news.images[currentImageIndex]}
            alt={news.title}
            fill
            sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
            priority={currentImageIndex === 0}
            className="object-cover transition-all duration-500 ease-in-out"
            onClick={nextImage}
            onError={handleImageError}
          />
        )}
        {!imageError && news.images.length > 1 && (
          <div
            className="absolute top-2 right-2 z-10 bg-white/50 rounded-full p-1 cursor-pointer hover:bg-white/75 transition-colors"
            onClick={nextImage}
          >
            <ChevronDown size={16} />
          </div>
        )}
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