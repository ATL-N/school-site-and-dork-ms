"use client";

import { useState } from "react";
import Link from "next/link";
import NewsCard from '../webcomponents/newscard'
import {
  ArrowRight,
  Book,
  Users,
  Trophy,
  Calendar,
  ChevronDown,
  ChevronUp,
} from "lucide-react";

const newsData = [
  {
    id: 1,
    title: "Annual Science Innovation Showcase",
    description:
      "Students demonstrate groundbreaking projects that showcase creativity and scientific prowess, highlighting Cyan Academy's commitment to innovative learning.",
    images: [
      "/images/facilities/basicschoolghana-newsfinal.jpg",
      "/images/facilities/time_with_ubas_12.jpg",
      "/images/facilities/Ghana-School-1.webp",
    ],
    fullContent:
      "The Annual Science Innovation Showcase at Cyan Academy brought together the brightest young minds to present their most innovative research projects. From sustainable energy solutions to advanced medical technologies, our students demonstrated exceptional problem-solving skills and creativity.",
  },
  {
    id: 2,
    title: "International Cultural Exchange Program",
    description:
      "Cyan Academy launches its first global student exchange program, connecting students from diverse backgrounds and fostering global understanding.",
    images: [
      "/images/facilities/2-29-754x424.jpg",
      "/images/facilities/images.jpeg",
      "/images/facilities/5fd5eb47-518b-408a-8fcc-bd5befded7b5-1024x663.jpeg",
    ],
    fullContent:
      "Our inaugural international cultural exchange program has successfully bridged cultural gaps, allowing students to learn, collaborate, and grow together. Participants shared unique perspectives, developed cross-cultural communication skills, and created lasting global connections.",
  },
  {
    id: 3,
    title: "Award-Winning Athletic Achievements",
    description:
      "Cyan Academy's sports teams excel in regional championships, demonstrating exceptional teamwork and athletic excellence.",
    images: [
      "/images/facilities/basicschoolghana-newsfinal.jpg",
      "/images/facilities/2-29-754x424.jpg",
      "/images/facilities/time_with_ubas_12.jpg",
    ],
    fullContent:
      "Our athletes have once again proven their mettle by winning multiple championships across various sports. Their dedication, discipline, and teamwork reflect the holistic development we promote at Cyan Academy.",
  },
];

// const NewsCard = ({ news }) => {
//   const [currentImageIndex, setCurrentImageIndex] = useState(0);
//   const [expanded, setExpanded] = useState(false);

//   const nextImage = () => {
//     setCurrentImageIndex((prev) => (prev + 1) % news.images.length);
//   };

//   return (
//     <div
//       className="rounded-lg overflow-hidden hover-scale animated-element relative"
//       style={{ backgroundColor: "var(--accent-color)" }}
//     >
//       <div className="relative">
//         <img
//           src={news.images[currentImageIndex]}
//           alt={news.title}
//           className="w-full h-48 object-cover transition-all duration-500 ease-in-out"
//           onClick={nextImage}
//         />
//         <div
//           className="absolute top-2 right-2 rounded-full p-1 cursor-pointer"
//           onClick={nextImage}
//         >
//           <ChevronDown size={16} />
//         </div>
//       </div>
//       <div className="p-6">
//         <h3 className="text-xl font-semibold mb-2">{news.title}</h3>
//         <p className="mb-4">{expanded ? news.fullContent : news.description}</p>
//         <div className="flex justify-between items-center">
//           {/* <Link
//             href="#"
//             className="inline-flex items-center"
//             style={{ color: "var(--primary-color)" }}
//           >
//             Read More <ArrowRight className="ml-2" size={16} />
//           </Link> */}
//           <button
//             onClick={() => setExpanded(!expanded)}
//             className="text-sm flex items-center"
//             style={{ color: "var(--primary-color)" }}
//           >
//             {expanded ? "Show Less" : "Expand"}
//             {expanded ? (
//               <ChevronUp className="ml-1" size={16} />
//             ) : (
//               <ChevronDown className="ml-1" size={16} />
//             )}
//           </button>
//         </div>
//       </div>
//     </div>
//   );
// };

export default function HomePage() {
  return (
    <main className="max-h-screen">
      {/* Hero Section */}
      <section className="pt-24 pb-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="text-center animated-element">
            <h1
              className="text-4xl sm:text-6xl font-bold mb-6"
              style={{ color: "var(--primary-color)" }}
            >
              Welcome to Cyan Academy
            </h1>
            <p className="text-xl mb-8 max-w-2xl mx-auto">
              Where innovation meets education. Shaping tomorrow's leaders
              through excellence in teaching and learning.
            </p>
            <Link
              href="/webpages/admissions"
              className="inline-flex items-center px-6 py-3 rounded-full text-white hover-scale shadow-lg transition-all duration-300"
              style={{
                backgroundColor: "var(--primary-color)",
                boxShadow:
                  "0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)",
              }}
            >
              Begin Your Journey <ArrowRight className="ml-2" />
            </Link>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section
        className="py-12 px-4 sm:px-6 lg:px-8"
        style={{ backgroundColor: "var(--accent-color2)" }}
      >
        <div className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-4 gap-8">
          <div
            className="text-center p-6 rounded-lg hover-scale animated-element shadow-md transition-all duration-300"
            style={{
              backgroundColor: "var(--background-color)",
              transform: "translateY(0)",
              transition:
                "transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out",
            }}
          >
            <Book
              className="mx-auto mb-4"
              size={40}
              style={{ color: "var(--primary-color)" }}
            />
            <h3 className="text-xl font-semibold mb-2">Modern Curriculum</h3>
            <p>Innovative learning approaches designed for the future</p>
          </div>
          <div
            className="text-center p-6 rounded-lg hover-scale animated-element shadow-md transition-all duration-300"
            style={{
              backgroundColor: "var(--background-color)",
              transform: "translateY(0)",
              transition:
                "transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out",
            }}
          >
            <Users
              className="mx-auto mb-4"
              size={40}
              style={{ color: "var(--primary-color)" }}
            />
            <h3 className="text-xl font-semibold mb-2">Expert Faculty</h3>
            <p>Dedicated teachers committed to student success</p>
          </div>
          <div
            className="text-center p-6 rounded-lg hover-scale animated-element shadow-md transition-all duration-300"
            style={{
              backgroundColor: "var(--background-color)",
              transform: "translateY(0)",
              transition:
                "transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out",
            }}
          >
            <Trophy
              className="mx-auto mb-4"
              size={40}
              style={{ color: "var(--primary-color)" }}
            />
            <h3 className="text-xl font-semibold mb-2">Excellence</h3>
            <p>Proven track record of academic achievement</p>
          </div>
          <div
            className="text-center p-6 rounded-lg hover-scale animated-element shadow-md transition-all duration-300"
            style={{
              backgroundColor: "var(--background-color)",
              transform: "translateY(0)",
              transition:
                "transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out",
            }}
          >
            <Calendar
              className="mx-auto mb-4"
              size={40}
              style={{ color: "var(--primary-color)" }}
            />
            <h3 className="text-xl font-semibold mb-2">Activities</h3>
            <p>Rich variety of extracurricular programs</p>
          </div>
        </div>
      </section>

      {/* News Section */}
      <section className="py-12 px-4 sm:px-6 lg:px-8 my-4">
        <div className="max-w-7xl mx-auto">
          <h2
            className="text-3xl font-bold mb-8 text-center text-transparent bg-clip-text bg-gradient-to-r "
            style={{ color: "var(--primary-color)" }}
          >
            Latest News
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {newsData.map((news) => (
              <NewsCard key={news.id} news={news} />
            ))}
          </div>
        </div>
      </section>
    </main>
  );
}
