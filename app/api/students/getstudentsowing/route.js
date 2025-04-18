import { NextResponse } from "next/server";
import db from "../../../lib/db";

// /api/students/getstudentsowing

export async function GET(req) {
  try {
    const { searchParams } = new URL(req.url);
    const query = searchParams.get("query");

    let sqlQuery;
    let queryParams = [];

    if (query) {
      // Search functionality
      const sanitizedQuery = `%${query}%`;
      sqlQuery = `
        SELECT 
          s.semester_id as id,
          s.semester_name, 
          TO_CHAR(s.start_date, 'YYYY-MM-DD') AS start_date,
          TO_CHAR(s.end_date, 'YYYY-MM-DD') AS end_date,
          s.status

        FROM 
          semesters s
        WHERE 
          (s.semester_name ILIKE $1) AND s.status!='active'
        ORDER BY 
          s.start_date
        LIMIT 10000
      `;
      queryParams = [sanitizedQuery];
    } else {
      // Complete semesters list
      sqlQuery = `
        SELECT 
          s.*, 
          c.class_name,
          s.last_name || ' ' || s.first_name AS name
          

        FROM 
          students s
        LEFT JOIN
          classes c ON s.class_id = c.class_id

        WHERE s.status != 'deleted' AND s.amountowed > 0
        
        ORDER BY 
          s.class_id, s.last_name, s.first_name

        LIMIT 10000;

      `;
    }

    const { rows } = await db.query(sqlQuery, queryParams);

    return NextResponse.json(rows, { status: 200 });
  } catch (error) {
    console.error("Database error:", error);
    return NextResponse.json(
      { error: "Internal Server Error" },
      { status: 500 }
    );
  }
}

export const dynamic = "force-dynamic";
