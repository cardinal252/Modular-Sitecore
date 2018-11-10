## Folder Structure

Core - For the most part core assemblies are very low level very generic integrations to encapsulate functionality that is not likely to change unless fundamental elements of Sitecore or the .Net framework change. Examples of this might be unit testable / pluggable wrappers for sending an email (note - not the composition of the email).

Kernel - Kernel is slightly more frequently changed than core, this is likely to be things like SSO type functionality on which your modules can depend. Any kernel changes should mandate a complete redeployment of the solution.

Modules - These are units of functionality present within the site, they would represent bundles of functionality that belong together and would be deployed together. They cannot be coupled to other modules except by loose coupling via Sitecore content or IoC containers. Modules are of the size of the developers choosing. Generally AT LEAST one module per site.

Services - The services are responsible for api type functionality. Services can choose not to rely on the platform