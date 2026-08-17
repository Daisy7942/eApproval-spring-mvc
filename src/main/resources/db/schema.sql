-- eapproval_backend.department definition

CREATE TABLE `department` (
  `department_id` bigint NOT NULL AUTO_INCREMENT,
  `department_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`department_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- eapproval_backend.vacation_type definition

CREATE TABLE `vacation_type` (
  `vacation_type_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `deduct_balance` tinyint(1) NOT NULL,
  `is_paid` tinyint(1) NOT NULL,
  `allow_half_day` tinyint(1) NOT NULL,
  `default_days` decimal(4,1) DEFAULT NULL,
  PRIMARY KEY (`vacation_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- eapproval_backend.team definition

CREATE TABLE `team` (
  `team_id` bigint NOT NULL AUTO_INCREMENT,
  `team_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `department_id` bigint NOT NULL,
  PRIMARY KEY (`team_id`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `team_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- eapproval_backend.employee definition

CREATE TABLE `employee` (
  `employee_id` bigint NOT NULL AUTO_INCREMENT,
  `employee_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `team_id` bigint DEFAULT NULL,
  `position` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `position_level` int DEFAULT NULL,
  `manager_id` bigint DEFAULT NULL,
  `remain_leave` decimal(4,1) DEFAULT NULL,
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `employee_code` (`employee_code`),
  KEY `fk_employee_team` (`team_id`),
  KEY `fk_employee_manager` (`manager_id`),
  CONSTRAINT `fk_employee_manager` FOREIGN KEY (`manager_id`) REFERENCES `employee` (`employee_id`),
  CONSTRAINT `fk_employee_team` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- eapproval_backend.notification definition

CREATE TABLE `notification` (
  `notification_id` bigint NOT NULL AUTO_INCREMENT,
  `employee_id` bigint NOT NULL,
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- eapproval_backend.signature definition

CREATE TABLE `signature` (
  `signature_id` bigint NOT NULL AUTO_INCREMENT,
  `owner_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `employee_id` bigint DEFAULT NULL,
  `image_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`signature_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `signature_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- eapproval_backend.document definition

CREATE TABLE `document` (
  `doc_id` bigint NOT NULL AUTO_INCREMENT,
  `document_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `employee_id` bigint NOT NULL,
  `approval_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_urgent` tinyint(1) DEFAULT '0',
  `draft_signature_id` bigint DEFAULT NULL,
  `signed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`doc_id`),
  KEY `employee_id` (`employee_id`),
  KEY `draft_signature_id` (`draft_signature_id`),
  CONSTRAINT `document_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`),
  CONSTRAINT `document_ibfk_2` FOREIGN KEY (`draft_signature_id`) REFERENCES `signature` (`signature_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- eapproval_backend.favorite definition

CREATE TABLE `favorite` (
  `favorite_id` bigint NOT NULL AUTO_INCREMENT,
  `employee_id` bigint NOT NULL,
  `doc_id` bigint NOT NULL,
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `uq_favorite` (`employee_id`,`doc_id`),
  KEY `employee_id` (`employee_id`),
  KEY `doc_id` (`doc_id`),
  CONSTRAINT `favorite_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`),
  CONSTRAINT `favorite_ibfk_2` FOREIGN KEY (`doc_id`) REFERENCES `document` (`doc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- eapproval_backend.vacation_request definition

CREATE TABLE `vacation_request` (
  `vacation_id` bigint NOT NULL AUTO_INCREMENT,
  `doc_id` bigint NOT NULL,
  `employee_id` bigint NOT NULL,
  `vacation_type_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `start_half` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `end_half` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `days` decimal(4,1) NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`vacation_id`),
  KEY `doc_id` (`doc_id`),
  KEY `employee_id` (`employee_id`),
  KEY `vacation_type_id` (`vacation_type_id`),
  CONSTRAINT `vacation_request_ibfk_1` FOREIGN KEY (`doc_id`) REFERENCES `document` (`doc_id`),
  CONSTRAINT `vacation_request_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`),
  CONSTRAINT `vacation_request_ibfk_3` FOREIGN KEY (`vacation_type_id`) REFERENCES `vacation_type` (`vacation_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- eapproval_backend.approval_line definition

CREATE TABLE `approval_line` (
  `approval_line_id` bigint NOT NULL AUTO_INCREMENT,
  `doc_id` bigint NOT NULL,
  `approver_id` bigint NOT NULL,
  `approval_order` int NOT NULL,
  `round` int NOT NULL DEFAULT '1',
  `signature_id` bigint DEFAULT NULL,
  `approval_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `approval_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `approved_at` datetime DEFAULT NULL,
  PRIMARY KEY (`approval_line_id`),
  UNIQUE KEY `uq_approval_line` (`doc_id`,`approver_id`,`round`),
  KEY `doc_id` (`doc_id`),
  KEY `approver_id` (`approver_id`),
  KEY `fk_approval_line_signature` (`signature_id`),
  CONSTRAINT `approval_line_ibfk_1` FOREIGN KEY (`doc_id`) REFERENCES `document` (`doc_id`),
  CONSTRAINT `approval_line_ibfk_2` FOREIGN KEY (`approver_id`) REFERENCES `employee` (`employee_id`),
  CONSTRAINT `fk_approval_line_signature` FOREIGN KEY (`signature_id`) REFERENCES `signature` (`signature_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- eapproval_backend.attachment definition

CREATE TABLE `attachment` (
  `attachment_id` bigint NOT NULL AUTO_INCREMENT,
  `doc_id` bigint NOT NULL,
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `uploaded_by` bigint NOT NULL,
  PRIMARY KEY (`attachment_id`),
  KEY `doc_id` (`doc_id`),
  KEY `uploaded_by` (`uploaded_by`),
  CONSTRAINT `attachment_ibfk_1` FOREIGN KEY (`doc_id`) REFERENCES `document` (`doc_id`),
  CONSTRAINT `attachment_ibfk_2` FOREIGN KEY (`uploaded_by`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- eapproval_backend.delegation definition

CREATE TABLE `delegation` (
  `delegation_id` bigint NOT NULL AUTO_INCREMENT,
  `doc_id` bigint NOT NULL,
  `original_approver_id` bigint NOT NULL,
  `delegated_to_id` bigint NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`delegation_id`),
  KEY `doc_id` (`doc_id`),
  KEY `original_approver_id` (`original_approver_id`),
  KEY `delegated_to_id` (`delegated_to_id`),
  CONSTRAINT `delegation_ibfk_1` FOREIGN KEY (`doc_id`) REFERENCES `document` (`doc_id`),
  CONSTRAINT `delegation_ibfk_2` FOREIGN KEY (`original_approver_id`) REFERENCES `employee` (`employee_id`),
  CONSTRAINT `delegation_ibfk_3` FOREIGN KEY (`delegated_to_id`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



ALTER TABLE document
  ADD COLUMN due_date DATE NULL AFTER is_urgent;