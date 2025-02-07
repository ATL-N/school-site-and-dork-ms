"use client";

import Link from "next/link";
import {
  Facebook,
  Twitter,
  Instagram,
  Mail,
  Phone,
  MapPin,
} from "lucide-react";

export default function Footer() {
  return (
    <footer
      className="py-12 px-4 sm:px-6 lg:px-8"
      style={{ backgroundColor: "var(--accent-color)" }}
    >
      <div className="max-w-7xl mx-auto">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div className="animated-element">
            <h3
              className="text-2xl font-bold mb-4"
              style={{ color: "var(--primary-color)" }}
            >
              Cyan Academy
            </h3>
            <p className="mb-4">
              Shaping tomorrow's leaders through excellence in education and
              innovation.
            </p>
            <div className="flex space-x-4">
              <Link href="#" className="hover-scale">
                <Facebook size={24} />
              </Link>
              <Link href="#" className="hover-scale">
                <Twitter size={24} />
              </Link>
              <Link href="#" className="hover-scale">
                <Instagram size={24} />
              </Link>
            </div>
          </div>

          <div className="animated-element">
            <h4 className="text-lg font-semibold mb-4">Quick Links</h4>
            <ul className="space-y-2">
              <li>
                <Link href="/about" className="hover:text-primary">
                  About Us
                </Link>
              </li>
              <li>
                <Link href="/academics" className="hover:text-primary">
                  Academics
                </Link>
              </li>
              <li>
                <Link href="/admissions" className="hover:text-primary">
                  Admissions
                </Link>
              </li>
              <li>
                <Link href="/facilities" className="hover:text-primary">
                  Facilities
                </Link>
              </li>
              <li>
                <Link href="/contact" className="hover:text-primary">
                  Contact
                </Link>
              </li>
            </ul>
          </div>

          <div className="animated-element">
            <h4 className="text-lg font-semibold mb-4">Contact Info</h4>
            <ul className="space-y-2">
              <li className="flex items-center">
                <MapPin size={20} className="mr-2" />
                123 Education Street, Academic City
              </li>
              <li className="flex items-center">
                <Phone size={20} className="mr-2" />
                +1 234 567 8900
              </li>
              <li className="flex items-center">
                <Mail size={20} className="mr-2" />
                info@cyanacademy.edu
              </li>
            </ul>
          </div>

          <div className="animated-element">
            <h4 className="text-lg font-semibold mb-4">School Hours</h4>
            <ul className="space-y-2">
              <li>Monday - Friday</li>
              <li>8:00 AM - 4:00 PM</li>
              <li className="mt-4 font-semibold">Office Hours</li>
              <li>Monday - Friday</li>
              <li>7:30 AM - 5:00 PM</li>
            </ul>
          </div>
        </div>

        <div className="mt-12 pt-8 border-t border-gray-600 text-center">
          <p>
            &copy; {new Date().getFullYear()} Cyan Academy. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}
