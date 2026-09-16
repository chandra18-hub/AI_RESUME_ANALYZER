-- AI Resume Analyzer Database
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS ai_resume_analyzer;
USE ai_resume_analyzer;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE resumes (
    resume_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_type VARCHAR(20),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE resume_analysis (
    analysis_id INT PRIMARY KEY AUTO_INCREMENT,
    resume_id INT NOT NULL,
    ats_score DECIMAL(5,2),
    resume_strength DECIMAL(5,2),
    missing_keywords TEXT,
    improvement_suggestions TEXT,
    analyzed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE CASCADE
);

CREATE TABLE skills (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE resume_skills (
    resume_id INT NOT NULL,
    skill_id INT NOT NULL,
    skill_level VARCHAR(30) DEFAULT 'Beginner',
    PRIMARY KEY (resume_id, skill_id),
    FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE
);

CREATE TABLE job_roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(100) NOT NULL UNIQUE,
    required_skills TEXT
);

CREATE TABLE resume_job_matches (
    resume_id INT NOT NULL,
    role_id INT NOT NULL,
    match_percentage DECIMAL(5,2),
    PRIMARY KEY (resume_id, role_id),
    FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES job_roles(role_id) ON DELETE CASCADE
);

-- Sample data
INSERT INTO skills (skill_name) VALUES
('Java'), ('Python'), ('SQL'), ('HTML'), ('CSS'), ('JavaScript');

INSERT INTO job_roles (role_name, required_skills) VALUES
('Software Developer', 'Java, SQL, Data Structures'),
('Python Developer', 'Python, SQL, Django'),
('Frontend Developer', 'HTML, CSS, JavaScript');

-- Useful queries
-- SELECT all resumes uploaded by a user
-- SELECT * FROM resumes WHERE user_id = 1;

-- Find resumes with ATS score above 70
-- SELECT r.file_name, a.ats_score
-- FROM resumes r
-- JOIN resume_analysis a ON r.resume_id = a.resume_id
-- WHERE a.ats_score > 70;

-- Display skills associated with a resume
-- SELECT r.file_name, s.skill_name, rs.skill_level
-- FROM resumes r
-- JOIN resume_skills rs ON r.resume_id = rs.resume_id
-- JOIN skills s ON rs.skill_id = s.skill_id
-- WHERE r.resume_id = 1;
