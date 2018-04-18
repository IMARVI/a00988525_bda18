// Cuantos actores hay?
// 102
match (p:Person)-[r:ACTED_IN]->() return p

// Cuantos productores hay?
// 8
match (p:Person)-[r:PRODUCED]->() return p

// Cuantos directores hay?
// 28
match (p:Person)-[r:DIRECTED]->() return p

// Cuantas peliculas hay?
// 32
match (m:Movie) return m, count(m)

// Quen ha escrito mas peliculas
// Lilly Wachowski y Lana Wachowski
match (p:Person)-[r:WROTE]->() return p,count(r) order by count(r) desc

// Top 5 de peliculas con mejor Rating
MATCH p=()-[r:REVIEWED]->(m:Movie) RETURN m, avg(r.rating) AS rating order by rating desc limit 5