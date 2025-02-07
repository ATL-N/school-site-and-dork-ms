"use client";

import { useState } from "react";

export default function ContactForm() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    subject: "",
    message: "",
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    // Handle form submission logic here
    console.log("Form submitted:", formData);
    // Reset form
    setFormData({
      name: "",
      email: "",
      subject: "",
      message: "",
    });
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label htmlFor="name" className="block text-sm font-medium mb-2">
            Full Name
          </label>
          <input
            type="text"
            id="name"
            name="name"
            value={formData.name}
            onChange={handleChange}
            required
            className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-opacity-50"
            style={{
              borderColor: "var(--accent-color)",
              focusRing: "var(--primary-color)",
            }}
          />
        </div>

        <div>
          <label htmlFor="email" className="block text-sm font-medium mb-2">
            Email Address
          </label>
          <input
            type="email"
            id="email"
            name="email"
            value={formData.email}
            onChange={handleChange}
            required
            className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-opacity-50"
            style={{
              borderColor: "var(--accent-color)",
              focusRing: "var(--primary-color)",
            }}
          />
        </div>
      </div>

      <div>
        <label htmlFor="subject" className="block text-sm font-medium mb-2">
          Subject
        </label>
        <input
          type="text"
          id="subject"
          name="subject"
          value={formData.subject}
          onChange={handleChange}
          required
          className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-opacity-50"
          style={{
            borderColor: "var(--accent-color)",
            focusRing: "var(--primary-color)",
          }}
        />
      </div>

      <div>
        <label htmlFor="message" className="block text-sm font-medium mb-2">
          Message
        </label>
        <textarea
          id="message"
          name="message"
          value={formData.message}
          onChange={handleChange}
          required
          rows={6}
          className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-opacity-50 resize-none"
          style={{
            borderColor: "var(--accent-color)",
            focusRing: "var(--primary-color)",
          }}
        />
      </div>

      <div className="text-center">
        <button
          type="submit"
          className="inline-flex items-center px-6 py-3 rounded-full text-white hover:opacity-90 transition duration-200"
          style={{ backgroundColor: "var(--primary-color)" }}
        >
          Send Message
        </button>
      </div>
    </form>
  );
}
