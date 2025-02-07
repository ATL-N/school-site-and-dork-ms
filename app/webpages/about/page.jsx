"use client";

import ImageGallery from "../../webcomponents/ImageGallery";
import { Users, Award, Target, Clock, Book, Globe, Heart, Star } from "lucide-react";

const galleryImages = [
  {
    url: "/images/facilities/basicschoolghana-newsfinal.jpg",
    caption: "Annual Science Fair 2024",
  },
  {
    url: "/images/facilities/images.jpeg",
    caption: "Sports Day Championship",
  },
  {
    url: "/images/facilities/time_with_ubas_12.jpg",
    caption: "Cultural Festival",
  },
  {
    url: "/images/facilities/5fd5eb47-518b-408a-8fcc-bd5befded7b5-1024x663.jpeg",
    caption: "Graduation Ceremony",
  },
  {
    url: "/images/facilities/2-29-754x424.jpg",
    caption: "International Exchange Program",
  },
  {
    url: "/images/facilities/Ghana-School-1.webp",
    caption: "Community Service Initiative",
  },
];

export default function About() {
  return (
    <main className="min-h-screen">
      {/* Hero Section */}
      <section className="pt-24 pb-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto text-center animated-element">
          <h1
            className="text-4xl sm:text-6xl font-bold mb-6"
            style={{ color: "var(--primary-color)" }}
          >
            About Cyan Academy
          </h1>
          <p className="text-xl mb-8 max-w-3xl mx-auto">
            Since 1995, we've been shaping minds and building futures through
            innovative education and unwavering commitment to excellence.
          </p>
        </div>
      </section>

      {/* Mission, Vision, and Motto */}
      <section
        className="py-12 px-4 sm:px-6 lg:px-8"
        style={{ backgroundColor: "var(--accent-color2)" }}
      >
        <div className="max-w-7xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {/* Mission */}
            <div
              className="p-6 rounded-lg shadow-md animated-element"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <Book
                className="mx-auto mb-4"
                size={40}
                style={{ color: "var(--primary-color)" }}
              />
              <h2
                className="text-2xl font-bold mb-4 text-center"
                style={{ color: "var(--text-color)" }}
              >
                Our Mission
              </h2>
              <p className="text-center" style={{ color: "var(--text-color)" }}>
                To empower students with comprehensive, transformative education
                that nurtures critical thinking, global citizenship, and
                personal excellence, preparing them to lead and innovate in an
                ever-changing world.
              </p>
            </div>

            {/* Vision */}
            <div
              className="p-6 rounded-lg shadow-md animated-element"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <Globe
                className="mx-auto mb-4"
                size={40}
                style={{ color: "var(--primary-color)" }}
              />
              <h2
                className="text-2xl font-bold mb-4 text-center"
                style={{ color: "var(--text-color)" }}
              >
                Our Vision
              </h2>
              <p className="text-center" style={{ color: "var(--text-color)" }}>
                To be a world-class educational institution that sets new
                standards in holistic learning, where every student is equipped
                to become a compassionate, innovative, and responsible global
                leader.
              </p>
            </div>

            {/* Motto */}
            <div
              className="p-6 rounded-lg shadow-md animated-element"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <Star
                className="mx-auto mb-4"
                size={40}
                style={{ color: "var(--primary-color)" }}
              />
              <h2
                className="text-2xl font-bold mb-4 text-center"
                style={{ color: "var(--text-color)" }}
              >
                Our Motto
              </h2>
              <p
                className="text-center text-xl italic"
                style={{ color: "var(--text-color)" }}
              >
                "Enlighten, Empower, Excel"
              </p>
              <p
                className="text-center mt-2 "
                style={{ color: "var(--text-color)" }}
              >
                A commitment to intellectual growth, personal empowerment, and
                achieving excellence in all endeavors.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Core Values */}
      <section
        className="py-12 px-4 sm:px-6 lg:px-8"
        style={{ backgroundColor: "var(--accent-color)" }}
      >
        <div className="max-w-7xl mx-auto">
          <h2 className="text-3xl font-bold mb-12 text-center">
            Our Core Values
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div
              className="text-center p-6 rounded-lg hover-scale animated-element"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <Users
                className="mx-auto mb-4"
                size={40}
                style={{ color: "var(--primary-color)" }}
              />
              <h3 className="text-xl font-semibold mb-2">Community</h3>
              <p>Fostering a supportive and inclusive learning environment</p>
            </div>
            <div
              className="text-center p-6 rounded-lg hover-scale animated-element"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <Award
                className="mx-auto mb-4"
                size={40}
                style={{ color: "var(--primary-color)" }}
              />
              <h3 className="text-xl font-semibold mb-2">Excellence</h3>
              <p>Striving for the highest standards in education</p>
            </div>
            <div
              className="text-center p-6 rounded-lg hover-scale animated-element"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <Target
                className="mx-auto mb-4"
                size={40}
                style={{ color: "var(--primary-color)" }}
              />
              <h3 className="text-xl font-semibold mb-2">Innovation</h3>
              <p>Embracing new ideas and methods in learning</p>
            </div>
            <div
              className="text-center p-6 rounded-lg hover-scale animated-element"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <Clock
                className="mx-auto mb-4"
                size={40}
                style={{ color: "var(--primary-color)" }}
              />
              <h3 className="text-xl font-semibold mb-2">Dedication</h3>
              <p>Committed to student success and growth</p>
            </div>
          </div>
        </div>
      </section>

      {/* Additional Core Values */}
      <section className="py-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div className="animated-element">
              <h2
                className="text-3xl font-bold mb-6"
                style={{ color: "var(--primary-color)" }}
              >
                Our Comprehensive Approach
              </h2>
              <p className="mb-4">
                At Cyan Academy, we believe in a holistic educational approach
                that goes beyond traditional academics. Our commitment extends
                to developing well-rounded individuals who are intellectually
                curious, socially responsible, and emotionally intelligent.
              </p>
              <p className="mb-4">
                We integrate academic rigor with character development, ensuring
                that our students are not just knowledgeable, but also ethical,
                empathetic, and prepared to make meaningful contributions to
                society.
              </p>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div
                className="p-4 rounded-lg text-center animated-element"
                style={{ backgroundColor: "var(--accent-color2)" }}
              >
                <Heart
                  className="mx-auto mb-2"
                  size={30}
                  style={{ color: "var(--primary-color)" }}
                />
                <h3 className="font-semibold">Social Responsibility</h3>
              </div>
              <div
                className="p-4 rounded-lg text-center animated-element"
                style={{ backgroundColor: "var(--accent-color2)" }}
              >
                <Globe
                  className="mx-auto mb-2"
                  size={30}
                  style={{ color: "var(--primary-color)" }}
                />
                <h3 className="font-semibold">Global Perspective</h3>
              </div>
              <div
                className="p-4 rounded-lg text-center animated-element"
                style={{ backgroundColor: "var(--accent-color2)" }}
              >
                <Star
                  className="mx-auto mb-2"
                  size={30}
                  style={{ color: "var(--primary-color)" }}
                />
                <h3 className="font-semibold">Personal Growth</h3>
              </div>
              <div
                className="p-4 rounded-lg text-center animated-element"
                style={{ backgroundColor: "var(--accent-color2)" }}
              >
                <Book
                  className="mx-auto mb-2"
                  size={30}
                  style={{ color: "var(--primary-color)" }}
                />
                <h3 className="font-semibold">Lifelong Learning</h3>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* History Section */}
      <section className="py-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
            <div className="animated-element">
              <h2
                className="text-3xl font-bold mb-6"
                style={{ color: "var(--primary-color)" }}
              >
                Our History
              </h2>
              <p className="mb-4">
                Founded in 1995, Cyan Academy began with a vision to
                revolutionize education through innovative teaching methods and
                a student-centered approach.
              </p>
              <p className="mb-4">
                Over the years, we've grown from a small institution of 50
                students to a leading academic center with over 1,000 students
                and 100 faculty members.
              </p>
              <p>
                Our commitment to excellence has earned us numerous accolades
                and recognitions, including the National Education Excellence
                Award in 2023.
              </p>
            </div>
            <div className="rounded-lg overflow-hidden animated-element">
              <img
                src="/images/facilities/2-29-754x424.jpg"
                alt="School History"
                className="w-full h-full object-cover"
              />
            </div>
          </div>
        </div>
      </section>

      {/* Gallery Section */}
      <section
        className="py-12 px-4 sm:px-6 lg:px-8 my-4 rounded shadow"
        style={{ backgroundColor: "var(--accent-color2)" }}
      >
        <div className="max-w-7xl mx-auto">
          <h2 className="text-3xl font-bold mb-12 text-center">
            Life at Cyan Academy
          </h2>
          <ImageGallery images={galleryImages} />
        </div>
      </section>
    </main>
  );
}