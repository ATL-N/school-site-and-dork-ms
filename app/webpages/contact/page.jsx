"use client";

// import Navbar from "../components/Navbar";
// import Footer from "../components/Footer";
import ContactForm from "../../webcomponents/ContactForm";
import { MapPin, Phone, Mail, Clock } from "lucide-react";

export default function Contact() {
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
            Get in Touch
          </h1>
          <p className="text-xl mb-8 max-w-3xl mx-auto">
            We're here to help! Reach out to us with any questions about
            admissions, academics, or campus life.
          </p>
        </div>
      </section>

      {/* Contact Cards */}
      <section
        className="py-12 px-4 sm:px-6 lg:px-8 rounded shadow my-4"
        style={{ backgroundColor: "var(--accent-color2)" }}
      >
        <div className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-4 gap-8">
          <div
            className="p-6 rounded-lg text-center hover-scale animated-element"
            style={{ backgroundColor: "var(--background-color)" }}
          >
            <MapPin
              className="mx-auto mb-4"
              size={40}
              style={{ color: "var(--primary-color)" }}
            />
            <h3 className="text-xl font-semibold mb-2">Visit Us</h3>
            <p>
              123 Education Avenue
              <br />
              Learning City, ST 12345
            </p>
          </div>

          <div
            className="p-6 rounded-lg text-center hover-scale animated-element"
            style={{ backgroundColor: "var(--background-color)" }}
          >
            <Phone
              className="mx-auto mb-4"
              size={40}
              style={{ color: "var(--primary-color)" }}
            />
            <h3 className="text-xl font-semibold mb-2">Call Us</h3>
            <p>
              Main Office: (555) 123-4567
              <br />
              Admissions: (555) 123-4568
            </p>
          </div>

          <div
            className="p-6 rounded-lg text-center hover-scale animated-element"
            style={{ backgroundColor: "var(--background-color)" }}
          >
            <Mail
              className="mx-auto mb-4"
              size={40}
              style={{ color: "var(--primary-color)" }}
            />
            <h3 className="text-xl font-semibold mb-2">Email Us</h3>
            <p>
              info@cyanacademy.edu
              <br />
              admissions@cyanacademy.edu
            </p>
          </div>

          <div
            className="p-6 rounded-lg text-center hover-scale animated-element"
            style={{ backgroundColor: "var(--background-color)" }}
          >
            <Clock
              className="mx-auto mb-4"
              size={40}
              style={{ color: "var(--primary-color)" }}
            />
            <h3 className="text-xl font-semibold mb-2">Office Hours</h3>
            <p>
              Monday - Friday: 8AM - 4PM
              <br />
              Saturday: 9AM - 12PM
            </p>
          </div>
        </div>
      </section>

      {/* Contact Form Section */}
      <section
        className="py-12 px-4 sm:px-6 lg:px-8 my-4"
        style={{ backgroundColor: "var(--accent-color)" }}
      >
        <div className="max-w-3xl mx-auto">
          <h2
            className="text-3xl font-bold mb-8 text-center"
            style={{ color: "var(--primary-color)" }}
          >
            Send Us a Message
          </h2>
          <div className="bg-white rounded-lg p-8 shadow-lg animated-element">
            <ContactForm />
          </div>
        </div>
      </section>

      {/* Map Section */}
      <section
        className="py-12 px-4 sm:px-6 lg:px-8 rounded shadow my-4 "
        style={{ backgroundColor: "var(--accent-color2)" }}
      >
        <div className="max-w-7xl mx-auto">
          <h2
            className="text-3xl font-bold mb-8 text-center"
            style={{ color: "var(--primary-color)" }}
          >
            Campus Location
          </h2>
          <div className="rounded-lg overflow-hidden shadow-lg animated-element h-96">
            <iframe
              src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2033295.9971275334!2d-2.0626901756924663!3d5.525225100000022!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0xfdfbb3a3f7cf52d%3A0xfc80f4f7fa3ce3b2!2sAPAM%20GREATER%20GRACE%20CHRISTIAN%20ACADEMY!5e0!3m2!1sen!2sgh!4v1738286332425!5m2!1sen!2sgh"
              width="100%"
              height="100%"
              style={{ border: 0 }}
              allowFullScreen=""
              loading="lazy"
            ></iframe>
          </div>
        </div>
      </section>

      {/* <Footer /> */}
    </main>
  );
}
