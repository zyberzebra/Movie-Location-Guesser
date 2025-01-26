package com.movielocguess.controller;

import com.movielocguess.model.Movie;
import com.movielocguess.service.GameService;
import io.github.bucket4j.Bucket;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
public class GameController {
    private final GameService gameService;
    private final Bucket rateLimitBucket;
    private Movie currentMovie;

    public GameController(GameService gameService, Bucket rateLimitBucket) {
        this.gameService = gameService;
        this.rateLimitBucket = rateLimitBucket;
    }

    @GetMapping("/")
    public String home(Model model) {
        if (!rateLimitBucket.tryConsume(1)) {
            model.addAttribute("error", "Rate limit exceeded. Please try again later.");
            return "error";
        }
        
        currentMovie = gameService.getRandomMovie();
        model.addAttribute("movie", currentMovie);
        return "game";
    }

    @PostMapping("/calculate-distance")
    @ResponseBody
    public ResponseEntity<?> calculateDistance(@RequestBody Map<String, Double> request) {
        if (!rateLimitBucket.tryConsume(1)) {
            return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS)
                    .body("Rate limit exceeded. Please try again later.");
        }

        if (currentMovie == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("No active game session");
        }

        try {
            double distance = gameService.calculateDistance(
                request.get("clickedLat"),
                request.get("clickedLng"),
                currentMovie.getLatitude(),
                currentMovie.getLongitude()
            );
            return ResponseEntity.ok(distance);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Invalid coordinates provided");
        }
    }
} 