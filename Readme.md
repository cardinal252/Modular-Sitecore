# Sitecore Bundle Architecture

This represents a helix alternative reference architecture to allow bundle based deployments in your sitecore solutions

## Archictecture Principles

### Dependency

* A bundle is a unit of work to be delivered.
* There are 2 types of bundle - core and module.
* Module bundles can only be tightly coupled to Core bundles and may be delivered in isolation.
* Core bundles may share dependencies and interdepend on each other - they are always delivered together.
* Module bundles may have loose coupling between them (e.g. via IoC containers or Sitecore content).
* Delivery projects may depend on 1 or more dependent projects within the same bundle (so long as it does not violate the other fundamentals).

### Delivery & Dependent Projects

Delivery projects are visual studio publishable projects that. Often they can be used as a way of bringing together functionality within a module or core group. Generally a bundle will have one single delivery project

Dependent projects are visual studio projects that will not be directly published as part of a build, they will be delivered within a module as part of a conduit.

## Conventions

### Folder Structure

Core - Core projects are not changed often, they are likely to be things like SSO type functionality on which your modules can depend. Any core changes should mandate a complete redeployment of the solution.

Modules - These are units of functionality present within the site, they would represent bundles of functionality that belong together and would be deployed together. They cannot be coupled to other modules except by loose coupling via Sitecore content or IoC containers. Modules are of the size of the developers choosing. Generally AT LEAST one module per site.

Build - This contains scripts to specifically help with automating the generation of the site for developers or the build server.

### Delivery

* NO 2 modules can ever deliver the same file

* All configuration should be set up for the deployment process - this usually means tokenised by default, developer configuration should be performed as patches as a rule

* Configuration files ending in .deploy should be enabled during the delivery pipeline

* MS configuration transforms should be avoided unless absolutely necessary.

### Development

* All developers have the same publish location, generally we use p drive for source and x drive for runtime code. There are many approaches to achieving having a P and X drive, you can either use the subst command (add it to registry keys to make it permanent), a mounted VHD or a partition.

* Developers should maintain their own connection strings in their runtime environment

* Only one delivery project per module

### Configuration

* App_Config\Connectionstrings.config.deploy - this must be controlled by the platform (usually in a core or from a build pipeline)
* App_Config\Include\\<Module Name>\xxx.config - configuration specific for a module
* App_Config\Include\zzzDeploy\\<Module Name>\xxx.config.deploy - configuration that can only be used on deployed servers (should be renamed by your build pipeline)
* App_Config\Include\zzzDeployCM\\<Module Name>\xxx.config.deploy - the entire zzzDeployCM folder should be removed for CD servers. Configuration that can only be used on deployed CM servers (should be renamed by your build pipeline)
* App_Config\Include\zzzDeployCD\\<Module Name>\xxx.config.deploy- the entire zzzDeployCD folder should be removed for CM servers. Configuration that can only be used on deployed CD servers (should be renamed by your build pipeline)
* App_Config\Include\zzzDeveloper\\<Module Name>\xxx.config - configuration to make the developers environments run

## Helpers

### Deployment helpers

DeploymentValidation.ps1 - This publishes all of the source and ensures that the file names are all isolated. In many scenarios, this could be ran by the build server on a CI pipeline to ensure developers haven't broken this rule

CompleteDeploy.ps1 - This is for getting your development environment up to date - it performs a publish of everything thing the source using the Dev profile.

### Project Generation

There are powershell scripts in the Templates folder.

./Templates/Delivery/CreateProject.ps1 -ProjectFolder "MyNewFeature" -ProjectName "xxx.MyNewFeature"
./Templates/Dependent/CreateProject.ps1 -ProjectFolder "MyNewFeature" -ProjectName "xxx.MyNewFeature"

Once generated (in the outputs directory beneath the conduit / module folder), these need to be copied to their final destination and added to the solution file for that area.

