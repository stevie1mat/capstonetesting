export async function GET() {
  try {
    const response = await fetch("http://trademinutes-users-api:8080/hello");
    const data = await response.json();
    return Response.json(data);
  } catch (err) {
    console.error("Failed to fetch users-api:", err);
    return Response.json({ message: "Failed to fetch users-api" }, { status: 500 });
  }
}
