import { configureSynced } from "@legendapp/state/sync";
import { syncedSupabase } from "@legendapp/state/sync-plugins/supabase";
import { observablePersistAsyncStorage } from "@legendapp/state/persist-plugins/async-storage";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { observable } from "@legendapp/state";
import "react-native-get-random-values";
import { v4 as uuidv4 } from "uuid";
import supabase from "./supabase";

const generateId = () => uuidv4();

const customSynced = configureSynced(syncedSupabase, {
  persist: {
    plugin: observablePersistAsyncStorage({ AsyncStorage }),
  },
  generateId,
  supabase,
  changesSince: "last-sync",
  fieldCreatedAt: "created_at",
});

export const scraps$ = observable(
  customSynced({
    supabase,
    collection: "scraps",
    select: (from) =>
      from.select("id, screenshot_url, note,voice_recording_url, created_at"),
    actions: ["read", "create", "update", "delete"],
    realtime: true,
    persist: {
      name: "scraps",
      retrySync: true,
    },
    retry: {
      infinite: true,
    },
  })
);
