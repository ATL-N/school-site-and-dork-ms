import { NextResponse } from "next/server";
import { getToken } from "next-auth/jwt";

export async function middleware(req) {
  const token = await getToken({ req, secret: process.env.NEXTAUTH_SECRET });
  const { pathname } = req.nextUrl;

  // Allow access to /webpages routes without authentication
  if (
    pathname.startsWith("/webpages") ||
    pathname.startsWith("/webcomponents") ||
    pathname == "/"
  ) {
    return NextResponse.next();
  }

  // Allow the requests if:
  // 1) It's a request for next-auth session & provider fetching
  // 2) The token exists
  if (pathname.includes("/api/auth") || token) {
    return NextResponse.next();
  }

  // Redirect to login page if the user is not authenticated
  if (!token && pathname !== "/authentication/login") {
    return NextResponse.redirect(new URL("/authentication/login", req.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - authentication/login, authentication/signUp, authentication/forgot-password (auth pages)
     */
    "/((?!api|_next/static|_next/image|favicon.ico|authentication/login|authentication/signUp|authentication/forgot-password|webpages|^$|/|app/webcomponents).*)",
  ],
};
