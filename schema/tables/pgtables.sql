

--Postgres conversion documented on wiki

-- -------------------------------------------------------------------------
-- BUILDING LOOKUP TABLE
--
-- @author  Benjamin Russell (benrr101@csh.rit.edu)
-- @descrip This table holds building codes and links them to numbers and
--          to the name of the building
-- -------------------------------------------------------------------------

DROP TABLE IF EXISTS buildings;
CREATE TABLE buildings (
    number      VARCHAR(5) PRIMARY KEY,
    code        VARCHAR(5) UNIQUE,
    name        VARCHAR(100),
    off_campus  BOOLEAN DEFAULT TRUE
);

-- -------------------------------------------------------------------------
-- Quarters Table
--
-- @author  Benjamin Russell (benrr101@csh.rit.edu)
-- @descrip Table for quarters. Although RIT changed their formatting for quarters
--          we convert their new format (2135) to the old format (20135) to
--          preserve sorting.
-- -------------------------------------------------------------------------

-- CREATE TABLE ------------------------------------------------------------
CREATE TABLE quarters (
  "quarter"     SMALLINT NOT NULL PRIMARY KEY CONSTRAINT positive_quarter CHECK (quarter>0),
  "start"       DATE NOT NULL,
  "end"         DATE NOT NULL,
  "breakstart"  DATE NOT NULL,
  "breakend"    DATE NOT NULL
);

->add departments
-- -------------------------------------------------------------------------
-- Courses table
--
-- @author  Benjamin Russell (benrr101@csh.rit.edu)
-- @descrip Table for courses. These are linked to departments and quarters
--          in a one quarter/department to many courses. These are also linked
--          to sections in a one course to many sections fashion.
-- -------------------------------------------------------------------------

-- TABLE CREATION ----------------------------------------------------------
CREATE TABLE courses (
  id          SERIAL PRIMARY KEY NOT NULL,
  quarter     SMALLINT NOT NULL CONSTRAINT positive_quarter CHECK (quarter>0) REFERENCES quarters(quarter) ON DELETE CASCADE ON UPDATE CASCADE,
  department  INT NOT NULL CONSTRAINT positive_department CHECK (department>0) REFERENCES departments(id) ON DELETE CASCADE ON UPDATE CASCADE,
  course      VARCHAR(4) NOT NULL,
  credits     SMALLINT NOT NULL DEFAULT 0 CONSTRAINT positive_credits CHECK (credits>0),
  title       VARCHAR(50) NOT NULL,
  description TEXT NOT NULL,
  UNIQUE (quarter, department, course)
);
