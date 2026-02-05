package com.example.my_pg;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    // No code needed! JpaRepository provides .save() and .findAll()
}
