"use client";

import { useState } from "react";
import { X, ChevronLeft, ChevronRight } from "lucide-react";
import Image from "next/image";

export default function ImageGallery({ images }) {
  const [selectedImage, setSelectedImage] = useState(null);
  const [currentIndex, setCurrentIndex] = useState(0);

  const openModal = (index) => {
    setSelectedImage(images[index]);
    setCurrentIndex(index);
  };

  const closeModal = () => {
    setSelectedImage(null);
  };

  const nextImage = () => {
    const newIndex = (currentIndex + 1) % images.length;
    setSelectedImage(images[newIndex]);
    setCurrentIndex(newIndex);
  };

  const prevImage = () => {
    const newIndex = (currentIndex - 1 + images.length) % images.length;
    setSelectedImage(images[newIndex]);
    setCurrentIndex(newIndex);
  };

  return (
    <div className="w-full">
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
        {images.map((image, index) => (
          <div
            key={index}
            className="relative overflow-hidden rounded-lg cursor-pointer hover-scale animated-element"
            onClick={() => openModal(index)}
          >
            <Image
              src={image.url}
              alt={image.caption}
              width={600}
              height={400}
              className="w-full h-64 object-cover"
              sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
            />
            <div className="absolute bottom-0 left-0 right-0 p-4 bg-gradient-to-t from-black to-transparent">
              <p className="text-white text-sm">{image.caption}</p>
            </div>
          </div>
        ))}
      </div>

      {selectedImage && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-90">
          <button
            className="absolute top-4 right-4 text-white hover:text-gray-300"
            onClick={closeModal}
          >
            <X size={32} />
          </button>

          <button
            className="absolute left-4 text-white hover:text-gray-300"
            onClick={prevImage}
          >
            <ChevronLeft size={48} />
          </button>

          <button
            className="absolute right-4 text-white hover:text-gray-300"
            onClick={nextImage}
          >
            <ChevronRight size={48} />
          </button>

          <div className="max-w-4xl max-h-90vh mx-4 animated-element">
            <Image
              src={selectedImage.url}
              alt={selectedImage.caption}
              width={1920}
              height={1080}
              className="max-w-full max-h-[80vh] object-contain"
              priority
            />
            <p className="text-white text-center mt-4">
              {selectedImage.caption}
            </p>
          </div>
        </div>
      )}
    </div>
  );
}
