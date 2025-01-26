package com.movielocguess.repository;

import com.movielocguess.model.Movie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface MovieRepository extends JpaRepository<Movie, Long> {
    @Query(value = "SELECT * FROM MOVIE ORDER BY RANDOM() LIMIT 1", nativeQuery = true)
    Movie findRandomMovie();
} 