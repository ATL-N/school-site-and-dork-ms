"use client";

// import Navbar from "../../components/Navbar";
// import Footer from "../../components/Footer";
import ContactForm from "../../webcomponents/ContactForm";
import { ClipboardCheck, DollarSign, Calendar, FileText } from "lucide-react";

export default function Admissions() {
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
            Join Our Community
          </h1>
          <p className="text-xl mb-8 max-w-3xl mx-auto">
            Begin your journey at Cyan Academy. We're looking for curious minds,
            creative thinkers, and passionate learners to join our diverse
            community.
          </p>
        </div>
      </section>

      {/* Process Steps */}
      <section
        className="py-12 px-4 sm:px-6 lg:px-8"
        style={{ backgroundColor: "var(--accent-color2)" }}
      >
        <div className="max-w-7xl mx-auto">
          <h2 className="text-3xl font-bold mb-12 text-center">
            Admission Process
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div
              className="relative p-6 rounded-lg hover-scale animated-element"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <div
                className="absolute -top-4 -left-4 w-8 h-8 rounded-full flex items-center justify-center text-white font-bold"
                style={{ backgroundColor: "var(--primary-color)" }}
              >
                1
              </div>
              <FileText
                className="mb-4"
                size={40}
                style={{ color: "var(--primary-color)" }}
              />
              <h3 className="text-xl font-semibold mb-2">Submit Application</h3>
              <p>
                Complete the online application form with all required documents
              </p>
            </div>
            <div
              className="relative p-6 rounded-lg hover-scale animated-element"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <div
                className="absolute -top-4 -left-4 w-8 h-8 rounded-full flex items-center justify-center text-white font-bold"
                style={{ backgroundColor: "var(--primary-color)" }}
              >
                2
              </div>
              <Calendar
                className="mb-4"
                size={40}
                style={{ color: "var(--primary-color)" }}
              />
              <h3 className="text-xl font-semibold mb-2">Schedule Interview</h3>
              <p>Book an interview slot for you and your child</p>
            </div>
            <div
              className="relative p-6 rounded-lg hover-scale animated-element"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <div
                className="absolute -top-4 -left-4 w-8 h-8 rounded-full flex items-center justify-center text-white font-bold"
                style={{ backgroundColor: "var(--primary-color)" }}
              >
                3
              </div>
              <ClipboardCheck
                className="mb-4"
                size={40}
                style={{ color: "var(--primary-color)" }}
              />
              <h3 className="text-xl font-semibold mb-2">Assessment</h3>
              <p>Complete academic assessment and campus tour</p>
            </div>
            <div
              className="relative p-6 rounded-lg hover-scale animated-element"
              style={{ backgroundColor: "var(--background-color)" }}
            >
              <div
                className="absolute -top-4 -left-4 w-8 h-8 rounded-full flex items-center justify-center text-white font-bold"
                style={{ backgroundColor: "var(--primary-color)" }}
              >
                4
              </div>
              <DollarSign
                className="mb-4"
                size={40}
                style={{ color: "var(--primary-color)" }}
              />
              <h3 className="text-xl font-semibold mb-2">Enrollment</h3>
              <p>Receive decision and complete enrollment process</p>
            </div>
          </div>
        </div>
      </section>

      {/* Requirements */}
      <section className="py-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <h2 className="text-3xl font-bold mb-12 text-center">
            Application Requirements
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-12">
            <div
              className="p-6 rounded-lg hover-scale animated-element"
              style={{ backgroundColor: "var(--accent-color)" }}
            >
              <h3 className="text-xl font-semibold mb-4">Required Documents</h3>
              <ul className="space-y-3">
                <li className="flex items-center">
                  <span
                    className="w-2 h-2 rounded-full mr-3"
                    style={{ backgroundColor: "var(--primary-color)" }}
                  ></span>
                  Completed application form
                </li>
                <li className="flex items-center">
                  <span
                    className="w-2 h-2 rounded-full mr-3"
                    style={{ backgroundColor: "var(--primary-color)" }}
                  ></span>
                  Previous academic records
                </li>
                <li className="flex items-center">
                  <span
                    className="w-2 h-2 rounded-full mr-3"
                    style={{ backgroundColor: "var(--primary-color)" }}
                  ></span>
                  Birth certificate
                </li>
                <li className="flex items-center">
                  <span
                    className="w-2 h-2 rounded-full mr-3"
                    style={{ backgroundColor: "var(--primary-color)" }}
                  ></span>
                  Passport-size photographs
                </li>
                <li className="flex items-center">
                  <span
                    className="w-2 h-2 rounded-full mr-3"
                    style={{ backgroundColor: "var(--primary-color)" }}
                  ></span>
                  Teacher recommendations
                </li>
              </ul>
            </div>
            <div
              className="p-6 rounded-lg hover-scale animated-element"
              style={{ backgroundColor: "var(--accent-color)" }}
            >
              <h3 className="text-xl font-semibold mb-4">
                Academic Requirements
              </h3>
              <ul className="space-y-3">
                <li className="flex items-center">
                  <span
                    className="w-2 h-2 rounded-full mr-3"
                    style={{ backgroundColor: "var(--primary-color)" }}
                  ></span>
                  Minimum GPA of 3.0
                </li>
                <li className="flex items-center">
                  <span
                    className="w-2 h-2 rounded-full mr-3"
                    style={{ backgroundColor: "var(--primary-color)" }}
                  ></span>
                  Satisfactory attendance record
                </li>
                <li className="flex items-center">
                  <span
                    className="w-2 h-2 rounded-full mr-3"
                    style={{ backgroundColor: "var(--primary-color)" }}
                  ></span>
                  English proficiency
                </li>
                <li className="flex items-center">
                  <span
                    className="w-2 h-2 rounded-full mr-3"
                    style={{ backgroundColor: "var(--primary-color)" }}
                  ></span>
                  Good conduct record
                </li>
                <li className="flex items-center">
                  <span
                    className="w-2 h-2 rounded-full mr-3"
                    style={{ backgroundColor: "var(--primary-color)" }}
                  ></span>
                  Age-appropriate for grade level
                </li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      {/* Contact Form Section */}
      <section
        className="py-12 px-4 sm:px-6 lg:px-8"
        style={{ backgroundColor: "var(--accent-color2)" }}
      >
        <div className="max-w-3xl mx-auto">
          <h2 className="text-3xl font-bold mb-12 text-center">
            Have Questions?
          </h2>
          <div className="bg-white rounded-lg p-8 shadow-lg animated-element">
            <ContactForm />
          </div>
        </div>
      </section>

      {/* <Footer /> */}
    </main>
  );
}
