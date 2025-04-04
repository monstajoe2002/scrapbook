import { createClient } from "@supabase/supabase-js";
import { Database } from "@/utils/database.types";

const supabase = createClient<Database>(
  process.env.EXPO_PUBLIC_SUPABASE_URL!,
  process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY!
);

export default supabase;
