SELECT e.id AS enrollment_id,
       e.reference_number AS term
  FROM dsc_enrollments AS e
  WHERE e.reference_number IS NOT NULL

UNION


SELECT e.id AS enrollment_id,
       c.first_name AS term
  FROM dsc_enrollments AS e
  JOIN dsc_contacts AS c ON e.applicant_contact_id = c.id

UNION

SELECT e.id AS enrollment_id,
       c.last_name AS term
  FROM dsc_enrollments AS e
  JOIN dsc_contacts AS c ON e.applicant_contact_id = c.id

UNION

SELECT e.id AS enrollment_id,
       c.email_address AS term
  FROM dsc_enrollments AS e
  JOIN dsc_contacts AS c ON e.applicant_contact_id = c.id

UNION

SELECT e.id AS enrollment_id,
       c.first_name AS term
  FROM dsc_enrollments AS e
  JOIN dsc_contacts AS c ON e.correspondence_contact_id = c.id

UNION

SELECT e.id AS enrollment_id,
       c.last_name AS term
  FROM dsc_enrollments AS e
  JOIN dsc_contacts AS c ON e.correspondence_contact_id = c.id

UNION

SELECT e.id AS enrollment_id,
       c.email_address AS term
  FROM dsc_enrollments AS e
  JOIN dsc_contacts AS c ON e.correspondence_contact_id = c.id

