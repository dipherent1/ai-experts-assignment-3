# Explanation

## What was the bug?

The refresh condition in `Client.request()` (`http_client.py`) did not handle the case where `oauth2_token` is a plain `dict` (not an `OAuth2Token` instance). When a dict was stored as the token, the guard `not self.oauth2_token` evaluated to `False` (non-empty dict is truthy) and `isinstance(self.oauth2_token, OAuth2Token)` also evaluated to `False`, so the entire condition short-circuited to `False`. No refresh was triggered, and because the subsequent `isinstance` check also failed, no `Authorization` header was ever added to the request.

## Why did it happen?

The original condition only considered two states: a falsy value (e.g. `None`) and a proper `OAuth2Token` that might be expired. It silently ignored a third valid state — a dict-shaped token — which the type annotation `Union[OAuth2Token, Dict[str, Any], None]` explicitly allows. The logic gap meant any dict token was treated as valid and non-expired, yet never used to build the header.

## Why does your fix solve it?

The fix replaces the compound condition with:

```python
if not isinstance(self.oauth2_token, OAuth2Token) or self.oauth2_token.expired:
    self.refresh_oauth2()
```

This triggers a refresh for **every** value that is not a live `OAuth2Token` — including `None`, a dict, or any other unexpected type — and also for an expired `OAuth2Token`. After `refresh_oauth2()` runs, `self.oauth2_token` is always a fresh `OAuth2Token`, so the subsequent `isinstance` check succeeds and the `Authorization` header is set correctly.

## One edge case the tests still don't cover

A token that is an `OAuth2Token` with `expires_at` set to exactly the current Unix timestamp (i.e., expiring _right now_). The `expired` property uses `>=`, so such a token is considered expired and a refresh is triggered — but a test that freezes time at that exact boundary second is not present. A race condition between the `expired` check and the actual request could also go untested.
