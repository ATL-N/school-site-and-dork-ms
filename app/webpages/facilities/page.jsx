"use client";

// import Navbar from "../components/Navbar";
// import Footer from "../components/Footer";
import FacilityTour from "../../webcomponents/FacilityTour";
import ImageGallery from "../../webcomponents/ImageGallery";

const facilityImages = [
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
export default function Facilities() {
  return (
    <main className="min-h-screen">
      {/* <Navbar /> */}

      {/* Hero Section */}
      <section className="pt-24 pb-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto text-center animated-element">
          <h1
            className="text-4xl sm:text-6xl font-bold mb-6"
            style={{ color: "var(--primary-color)" }}
          >
            World-Class Facilities
          </h1>
          <p className="text-xl mb-8 max-w-3xl mx-auto">
            Explore our state-of-the-art campus designed to provide the best
            learning environment for our students.
          </p>
        </div>
      </section>

      {/* Virtual Tour */}
      <section
        className="py-12 px-4 sm:px-6 lg:px-8 mb-5 rounded shadow my-4"
        style={{ backgroundColor: "var(--accent-color2)" }}
      >
        <div className="max-w-7xl mx-auto">
          <h2 className="text-3xl font-bold mb-4 text-center">
            Take a Virtual Tour
          </h2>
          <FacilityTour />
        </div>
      </section>

      {/* Gallery */}
      <section
        className="py-12 px-4 sm:px-6 lg:px-8 mb-5 rounded shadow-2xl"
        // style={{ backgroundColor: "var(--accent-color)" }}
      >
        <div className="max-w-7xl mx-auto">
          <h2 className="text-3xl font-bold mb-12 text-center">
            Facility Gallery
          </h2>
          <ImageGallery images={facilityImages} />
        </div>
      </section>

      {/* Facilities List */}
      <section
        className="py-12 px-4 sm:px-6 lg:px-8 mb-4 rounded shadow-2xl"
        style={{ backgroundColor: "var(--background-color)" }}
      >
        <div className="max-w-7xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {/* Academic Facilities */}
            <div
              className="p-6 rounded-lg hover-scale animated-element shadow-2xl"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <h3
                className="text-2xl font-bold mb-4"
                style={{ color: "var(--primary-color)" }}
              >
                Academic Facilities
              </h3>
              <ul className="space-y-3">
                <li>Smart Classrooms</li>
                <li>Science Laboratories</li>
                <li>Computer Labs</li>
                <li>Digital Library</li>
                <li>Language Lab</li>
                <li>STEM Center</li>
              </ul>
            </div>

            {/* Sports Facilities */}
            <div
              className="p-6 rounded-lg hover-scale animated-element shadow-2xl"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <h3
                className="text-2xl font-bold mb-4"
                style={{ color: "var(--primary-color)" }}
              >
                Sports Facilities
              </h3>
              <ul className="space-y-3">
                <li>Indoor Sports Complex</li>
                <li>Swimming Pool</li>
                <li>Basketball Courts</li>
                <li>Football Field</li>
                <li>Tennis Courts</li>
                <li>Fitness Center</li>
              </ul>
            </div>

            {/* Additional Facilities */}
            <div
              className="p-6 rounded-lg hover-scale animated-element shadow-2xl"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <h3
                className="text-2xl font-bold mb-4"
                style={{ color: "var(--primary-color)" }}
              >
                Additional Facilities
              </h3>
              <ul className="space-y-3">
                <li>Cafeteria</li>
                <li>Medical Center</li>
                <li>Counseling Center</li>
                <li>Art Studio</li>
                <li>Music Rooms</li>
                <li>Transport Services</li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      {/* <Footer /> */}
    </main>
  );
}
