package com.salas.mynewproject.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/v1")
public class MyRestController {

    @GetMapping
    public String hello() {
        return "Hello World";
    }
}
