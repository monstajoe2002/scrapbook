import { createClient } from "@supabase/supabase-js";
import { configureSynced } from "@legendapp/state/sync";
import { syncedSupabase } from "@legendapp/state/sync-plugins/supabase";
import { observablePersistAsyncStorage } from "@legendapp/state/persist-plugins/async-storage";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { observable } from "@legendapp/state";
import "react-native-get-random-values";
import { v4 as uuidv4 } from "uuid";
import { Database } from "@/utils/database.types";
const supabase = createClient<Database>(
  process.env.EXPO_PUBLIC_SUPABASE_URL!,
  process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY!
);

const generateId = () => uuidv4();
// create a configured sync function
const customSynced = configureSynced(syncedSupabase, {
  persist: {
    plugin: observablePersistAsyncStorage({ AsyncStorage }),
  },
  generateId,
  supabase,
  changesSince: "last-sync",
  fieldCreatedAt: "created_at",
  // fieldUpdatedAt: "updated_at",
});

export const scraps$ = observable(
  customSynced({
    supabase,
    collection: "scraps",
    select: (from) =>
      from.select("id, screenshot_url, note,voice_recording_url, created_at"),
    actions: ["read", "create", "update", "delete"],
    realtime: true, // Enable realtime updates
    persist: {
      name: "scraps", // Name of the persisted collection
      retrySync: true, // Persist pending changes and retry
    },
    retry: {
      infinite: true, // Retry changes with exponential backoff
    },
  })
);
