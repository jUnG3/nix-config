---
name: LinkedIn Contact Research
description: Identify evidence-backed contacts for a selected LinkedIn job or freelance project, separating explicitly responsible people from likely contacts without contacting anyone.
---

# LinkedIn contact research

Use this skill for a focused contact lookup after the user selects an opportunity. Do not research contacts across an entire shortlist. The calling hunter performs this task and returns findings to Sales; do not spawn another agent or contact anyone.

## Prerequisites and tool mechanics

- Require the selected opportunity's reference, URL or ID, type, full available description, employer/client or intermediary, and any already named contact with source evidence. Return clarification questions to Sales if the selection is ambiguous.
- Load linkedin-search before any LinkedIn call unless already loaded in this session. Use its current tool discovery, schema inspection, read-only boundary, and bounded recovery policy. If either required skill or a required capability is unavailable, report the limitation rather than guessing tools or bypassing permissions.
- This is a targeted follow-up, not a new opportunity search. Apply any stricter budget from Sales; otherwise use at most 1 selected-opportunity detail refresh, 2 targeted contact-search queries, and 3 candidate profile/detail lookups. Use only supported pagination within those totals. Recovery attempts follow linkedin-search and do not reset counters.
- Do not upload project history or the skill profile. Contact lookup normally needs only the opportunity and organization details.

## Research sequence

1. Inspect contacts explicitly named in the selected description or posting's contact/poster fields. Follow explicit directions about who handles enquiries or whether direct contact is welcome.
2. For employment, prioritize the person explicitly assigned to the role. A named job poster or recruiter may be a relevant contact, but posting the job alone does not prove hiring ownership. Do not substitute an arbitrary HR employee or executive.
3. For freelance projects, prioritize the named project contact or request author. Check whether they represent an intermediary, recruiter, or end client. A repost author is not necessarily the original requester, and a recruiter is not automatically the end client.
4. If no explicit contact is available, use supported read-only LinkedIn person/profile capabilities to look for a small number of relevant candidates tied to the correct organization and role/project. Search results or a matching name alone do not establish identity or responsibility.
5. Check organization, current role where available, and evidence connecting each candidate to this specific opportunity. Prefer direct posting evidence over general organizational relevance. Record contradictions, stale affiliations, and inaccessible details.
6. Stop when there is a supported recommendation or the bounded lookup is exhausted. Do not expand into unrelated personal research, scrape private data, guess email patterns, or use an unapproved external service.

## Classification

Separate verified identity/affiliation from evidence of responsibility:

- **Explicitly responsible:** the opportunity or another directly relevant source explicitly names the person as the contact responsible for this role/project. Cite that statement and source.
- **Likely contact:** identity and relevant affiliation are supported, but responsibility for this particular opportunity is not explicit. Explain the link and its limitation. This includes a poster without explicit responsibility unless stronger evidence exists.
- **Unknown:** evidence is insufficient or conflicting. Do not invent a contact to fill the result.

Do not assign fabricated confidence percentages. A public profile, job title, or recruiter role alone is not proof of opportunity ownership. Preserve any source's exact relationship description rather than upgrading it.

## Communication and privacy boundaries

- Read-only lookup only: never message, connect, follow, comment, apply, submit forms, or otherwise modify accounts. Do not use write tools as connectivity tests.
- Report only professional details needed for this opportunity. Do not collect home addresses, private phone numbers, or unrelated personal information.
- Never invent a profile URL, name, title, gender, email address, or recipient identity. If an official professional contact address is explicitly supplied in the posting, retain its source; do not infer addresses from naming conventions.
- Report explicit no-contact or application-channel instructions. Do not recommend circumventing them.
- Captcha/sign-in, permission failures, and rate limits follow linkedin-search: stop or recover only within its policy, and route user intervention through Sales.

## Required handoff to Sales

Return:

1. **Status:** Complete, Partial, or Blocked; selected opportunity reference/URL; lookup date; tools/sources actually checked; budget use and limitations. Complete may mean no responsible contact could be established.
2. **Candidates:** a compact table with name, professional role, organization, profile URL if verified, client/intermediary relationship, responsibility classification, supporting source links and concise evidence, and any contradictions. Do not create rows for invented candidates.
3. **Recommendation:** identify an explicitly responsible contact if established. For a likely contact, ask Sales to obtain user confirmation before treating them as the intended recipient. If responsibility remains unknown or confirmation is declined, recommend a neutral greeting with no named recipient.
4. **Drafting handoff:** verified name/role if appropriate, responsibility classification and evidence, opportunity relationship, channel or no-contact restrictions, and unresolved questions. Preserve the previously agreed description/outreach language; do not infer language from the contact's name or location.

Nothing has been sent. Sales passes the contact evidence and the user's recipient decision to proposal_maker; the writer must not present a likely contact as a verified responsible person.
