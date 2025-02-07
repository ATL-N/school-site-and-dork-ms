import { NextResponse } from "next/server";
import db from "../../../../lib/db";

// /api/feedingNtransport/pickup/get
export async function GET(req) {
  try {
    const { searchParams } = new URL(req.url);
    const query = searchParams.get("query");
    const id = searchParams.get("id");

    let sqlQuery;
    let queryParams = [];

    if (id) {
      // Get single pick-up point by ID
      const pickUpId = parseInt(id, 10);
      if (isNaN(pickUpId)) {
        return NextResponse.json(
          { error: "Invalid ID format" },
          { status: 400 }
        );
      }

      sqlQuery = `
        SELECT 
          p.pick_up_id as id,
          p.pick_up_point_name,
          p.pick_up_price
        FROM 
          bus_pick_up_points p
        WHERE 
          p.pick_up_id = $1 AND p.status='active'
        LIMIT 1
      `;
      queryParams = [pickUpId];
    } else if (query) {
      // Search functionality
      const sanitizedQuery = `%${query}%`;
      sqlQuery = `
        SELECT 
          p.pick_up_id as id,
          p.pick_up_point_name,
          p.pick_up_price
        FROM 
          bus_pick_up_points p
        WHERE 
          (p.pick_up_point_name ILIKE $1) AND p.status='active'
        ORDER BY 
          p.pick_up_point_name DESC
        LIMIT 1000
      `;
      queryParams = [sanitizedQuery];
    } else {
      // Complete pick up points list
      sqlQuery = `
        SELECT 
          p.pick_up_id as id,
          p.pick_up_point_name,
          p.pick_up_price
        FROM 
          bus_pick_up_points p
        WHERE p.status = 'active'
        ORDER BY 
          p.pick_up_point_name DESC
        LIMIT 1000
      `;
    }

    const { rows } = await db.query(sqlQuery, queryParams);

    return NextResponse.json(id ? rows[0] || null : rows, { status: 200 });
  } catch (error) {
    console.error("Database error:", error);
    return NextResponse.json(
      { error: "Internal Server Error" },
      { status: 500 }
    );
  }
}

export const dynamic = "force-dynamic";
