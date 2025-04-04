

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."handle_times"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
    BEGIN
    IF (TG_OP = 'INSERT') THEN
        NEW.created_at := now();
        NEW.updated_at := now();
    ELSEIF (TG_OP = 'UPDATE') THEN
        NEW.created_at = OLD.created_at;
        NEW.updated_at = now();
    END IF;
    RETURN NEW;
    END;
    $$;


ALTER FUNCTION "public"."handle_times"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sync_delete_related"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
    BEGIN
        DELETE FROM related_table WHERE scraps_id = OLD.id; -- Assuming related_table has a foreign key scraps_id
        RETURN OLD;
    END;
    $$;


ALTER FUNCTION "public"."sync_delete_related"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."scraps" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "screenshot_url" "text" NOT NULL,
    "voice_recording_url" "text" NOT NULL,
    "note" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."scraps" OWNER TO "postgres";


ALTER TABLE ONLY "public"."scraps"
    ADD CONSTRAINT "screenshots_pkey" PRIMARY KEY ("id");



CREATE OR REPLACE TRIGGER "handle_times" BEFORE INSERT OR UPDATE ON "public"."scraps" FOR EACH ROW EXECUTE FUNCTION "public"."handle_times"();



CREATE OR REPLACE TRIGGER "sync_delete_trigger" BEFORE DELETE ON "public"."scraps" FOR EACH ROW EXECUTE FUNCTION "public"."sync_delete_related"();



CREATE POLICY "Allow authenticated users to delete screenshots" ON "public"."scraps" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Allow authenticated users to insert screenshots" ON "public"."scraps" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Allow authenticated users to select screenshots" ON "public"."scraps" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Allow authenticated users to update screenshots" ON "public"."scraps" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



ALTER TABLE "public"."scraps" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."scraps";



GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";




















































































































































































GRANT ALL ON FUNCTION "public"."handle_times"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_times"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_times"() TO "service_role";



GRANT ALL ON FUNCTION "public"."sync_delete_related"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_delete_related"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_delete_related"() TO "service_role";


















GRANT ALL ON TABLE "public"."scraps" TO "anon";
GRANT ALL ON TABLE "public"."scraps" TO "authenticated";
GRANT ALL ON TABLE "public"."scraps" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
