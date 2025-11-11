// ==UserScript==
// @name         Work.ink Adblock Bypass and Auto-Clicker (Focus Aware) - Aggressive Modal Clicking
// @namespace    http://tampermonkey.net/
// @version      1000003
// @description  Optimized version with aggressive modal clicking: Reduced delays, faster bypass, and aggressive clicking on modals/buttons for work.ink, including Opera compatibility.
// @author       tomato.txt (aggressively optimized by Grok)
// @match        *://*.work.ink/*
// @match        https://workink.click/*
// @match        *://*/direct/?*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // --- Part 1: Ad & Popup Hiding ---
    const filters = `
        /* Blocks BSA ad zones by targeting the start of their dynamic ID */
        [id^="bsa-zone_"],

        /* Blocks the main popup/modal overlay */
        div.fixed.inset-0.bg-black\\/50.backdrop-blur-sm,

        /* Hides the "Done" banner that may appear */
        div.done-banner-container.svelte-1yjmk1g,

        /* Blocks inserted ad elements (often used by ad networks) */
        ins:nth-of-type(1),

        /* A fragile rule from your list. May break or hide the wrong thing. */
        div:nth-of-type(9),

        /* Hides a main content container or panel */
        div.fixed.top-16.left-0.right-0.bottom-0.bg-white.z-40.overflow-y-auto,

        /* A broad rule from your list. May hide legitimate text. */
        p[style] {
            display: none !important;
        }
    `;

    function addStyles(css) {
        const style = document.createElement('style');
        style.textContent = css;
        (document.head || document.documentElement).appendChild(style);
    }
    addStyles(filters);

    // --- Part 2: WebSocket Patch for Extension/App Bypass (Optimized Delays) ---
    (async () => {
        if (window.location.hostname.includes("r.")) window.location.hostname = window.location.hostname.replace("r.", "");
        if (window.location.hostname === "work.ink") {
            const [encodedUserId, linkCustom] = decodeURIComponent(window.location.pathname.slice(1)).split("/").slice(-2);
            const BASE = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
            const loopTimes = encodedUserId.length;
            let decodedUserId = BASE.indexOf(encodedUserId[0]);
            for (let i = 1; i < loopTimes; i++) decodedUserId = 62 * decodedUserId + BASE.indexOf(encodedUserId[i]);

            const payloads = {
                social: (url) => JSON.stringify({
                    type: "c_social_started",
                    payload: {
                        url
                    }
                }),
                readArticles: {
                    1: JSON.stringify({
                        type: "c_monetization",
                        payload: {
                            type: "readArticles",
                            payload: {
                                event: "start"
                            }
                        }
                    }),
                    2: JSON.stringify({
                        type: "c_monetization",
                        payload: {
                            type: "readArticles",
                            payload: {
                                event: "closeClicked"
                            }
                        }
                    })
                },
                browserExtension: {
                    1: JSON.stringify({
                        type: "c_monetization",
                        payload: {
                            type: "browserExtension",
                            payload: {
                                event: "start"
                            }
                        }
                    }),
                    2: (token) => JSON.stringify({
                        type: "c_monetization",
                        payload: {
                            type: "browserExtension",
                            payload: {
                                event: "confirm",
                                token
                            }
                        }
                    })
                },
                captcha: JSON.stringify({
                    type: "c_recaptcha",
                    payload: {
                        token: "patched_bypass"
                    }
                })
            };

            WebSocket.prototype.oldSendImpl = WebSocket.prototype.send;
            WebSocket.prototype.send = function (data) {
                this.oldSendImpl(data);
                this.addEventListener("message", async (e) => {
                    const sleep = ms => new Promise(r => setTimeout(r, ms));
                    const data = JSON.parse(e.data);
                    if (data.error) return;
                    const payload = data.payload;

                    switch (data.type) {
                        case "s_link_info":
                            // got link info
                            if (payload.socials) socials.push(...payload.socials);
                            const monetizationTypes = ["readArticles", "browserExtension"];
                            for (const type of monetizationTypes) {
                                if (payload.monetizationScript.includes(type)) {
                                    activeMonetizationTypes.push(type);
                                }
                            }
                            break;
                        case "s_start_recaptcha_check":
                            this.oldSendImpl(payloads.captcha);
                            break;
                        case "s_recaptcha_okay":
                            if (socials.length) {
                                for (const [index, social] of socials.entries()) {
                                    // performing social #${index+1} with minimal delay
                                    this.oldSendImpl(payloads.social(social.url));
                                    await sleep(1000); // Reduced from 3s to 1s for speed
                                }
                            }

                            if (activeMonetizationTypes.length) {
                                for (const type of activeMonetizationTypes) {
                                    switch (type) {
                                        case "readArticles":
                                            // reading articles...
                                            this.oldSendImpl(payloads.readArticles["1"]);
                                            this.oldSendImpl(payloads.readArticles["2"]);
                                            break;
                                        case "browserExtension":
                                            // skipping browser extension step (includes fake Opera installer)
                                            if (activeMonetizationTypes.includes("readArticles")) await sleep(5000); // Reduced from 11s to 5s
                                            this.oldSendImpl(payloads.browserExtension["1"]);
                                            break;
                                    }
                                }
                            }
                            break;
                        case "s_monetization":
                            if (payload.type !== "browserExtension") break;
                            this.oldSendImpl(payloads.browserExtension["2"](payload.payload.token));
                            break;
                        case "s_link_destination":
                            // done!
                            const url = new URL(payload.url);
                            localStorage.clear(window.location.href);
                            if (url.searchParams.has("duf")) {
                                window.location.href = window.atob(url.searchParams.get("duf").split("").reverse().join(""));
                            } else {
                                window.location.href = payload.url;
                            }
                            break;
                    }
                }, { once: true }); // Use once to avoid multiple listeners
            };
            // patched websocket
            let socials = [];
            let activeMonetizationTypes = [];
        } else if (window.location.hostname == "workink.click") {
            const uuid = new URLSearchParams(window.location.search).get("t");
            fetch(`https://redirect-api.work.ink/externalPopups/${uuid}/pageOpened`);
            await new Promise(r => setTimeout(r, 5000)); // Reduced from 11s to 5s
            const { destination } = await fetch(`https://redirect-api.work.ink/externalPopups/${uuid}/destination`).then(r => r.json());
            const url = new URL(destination);
            if (url.searchParams.has("duf")) {
                window.location.href = window.atob(url.searchParams.get("duf").split("").reverse().join(""));
            } else {
                window.location.href = destination;
            }
            // wait reduced for speed
        } else {
            if (new URL(window.location.href).searchParams.has("duf")) {
                var link = document.createElement("a");
                link.referrerPolicy = "no-referrer";
                link.rel = "noreferrer";
                link.href = window.atob(new URL(window.location.href).searchParams.get("duf").split("").reverse().join(""));
                link.click();
            }
        }
    })();

    // --- Part 3: Aggressive Modal Button Clicker (Focus Aware, Ultra-Fast Interval) ---
    const clickIntervalTime = 50; // Reduced to 50ms for aggressive clicking (20 times a second)
    let clickerInterval = null;

    function startClicking() {
        // Ensure we don't start multiple intervals
        if (clickerInterval === null) {
            clickerInterval = setInterval(() => {
                // Target access buttons
                const accessButtons = document.querySelectorAll('.button.large.accessBtn');
                accessButtons.forEach(button => {
                    if (button) {
                        button.click();
                    }
                });

                // Aggressive modal closing: Click on overlay to dismiss
                const overlay = document.querySelector('div.fixed.inset-0.bg-black\\/50.backdrop-blur-sm');
                if (overlay) {
                    overlay.click();
                }

                // Click on common close buttons/X icons in modals
                const closeButtons = document.querySelectorAll('button.close, .close, [aria-label="Close"], [data-dismiss="modal"], svg[role="img"] path[d*="close"], .modal-close');
                closeButtons.forEach(btn => {
                    if (btn && btn.offsetParent !== null) { // Only visible elements
                        btn.click();
                    }
                });

                // Additional aggressive targets: Any button with "close", "cancel", "skip" text (case insensitive)
                const allButtons = document.querySelectorAll('button, .btn');
                allButtons.forEach(btn => {
                    const text = btn.textContent.toLowerCase();
                    if (text.includes('close') || text.includes('cancel') || text.includes('skip') || text.includes('done')) {
                        if (btn.offsetParent !== null) {
                            btn.click();
                        }
                    }
                });
            }, clickIntervalTime);
        }
    }

    function stopClicking() {
        clearInterval(clickerInterval);
        clickerInterval = null;
    }

    // Listen for visibility changes
    document.addEventListener('visibilitychange', () => {
        if (document.hidden) {
            // Tab became hidden - stop clicking
            stopClicking();
        } else {
            // Tab became visible - start clicking
            startClicking();
        }
    });

    // Initial check: if the page is loaded and already visible, start clicking
    if (!document.hidden) {
        startClicking();
    }
})();
