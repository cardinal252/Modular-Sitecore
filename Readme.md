# Sitecore Bundle Architecture

This represents a helix alternative architecture to allow bundle based deployments in your sitecore solutions

## Fundamentals

NO 2 modules can ever deliver the same file

All developers have the same publish location, generally we use p drive for source and x drive for runtime code. There are many approaches to achieving having a P and X drive, you can either use the subst command (add it to registry keys to make it permanent), a mounted VHD or a partition.

All configuration should be set up for the deployment process - this usually means tokenised by default, developer configuration should be performed as patches as a rule

Developers should maintain their own connection strings in their runtime environment

## Folder Structure

Core - For the most part core assemblies are very low level very generic integrations to encapsulate functionality that is not likely to change unless fundamental elements of Sitecore or the .Net framework change. Examples of this might be unit testable / pluggable wrappers for sending an email (note - not the composition of the email).

Kernel - Kernel is slightly more frequently changed than core, this is likely to be things like SSO type functionality on which your modules can depend. Any kernel changes should mandate a complete redeployment of the solution.

Platform - This is a composition of Sitecore modules plus core & kernel deliverables

Modules - These are units of functionality present within the site, they would represent bundles of functionality that belong together and would be deployed together. They cannot be coupled to other modules except by loose coupling via Sitecore content or IoC containers. Modules are of the size of the developers choosing. Generally AT LEAST one module per site.

Services - The services are responsible for api type functionality. Services can choose not to rely on the platform

Build - This contains scripts to specifically help with automating the generation of the site for developers or the build server.


## Configuration Conventions

* App_Config\Connectionstrings.config.deploy - this must be controlled by the platform (usually in a kernel or from a build pipeline)
* App_Config\Include\<Module Name>\xxx.config - configuration specific for a module
* App_Config\Include\zzzDeploy\<Module Name>\xxx.config.deploy - configuration that can only be used on deployed servers (should be renamed by your build pipeline)
* App_Config\Include\zzzDeployCM\<Module Name>\xxx.config.deploy - the entire zzzDeployCM folder should be removed for CD servers. Configuration that can only be used on deployed CM servers (should be renamed by your build pipeline)
* App_Config\Include\zzzDeployCD\<Module Name>\xxx.config.deploy- the entire zzzDeployCD folder should be removed for CM servers. Configuration that can only be used on deployed CD servers (should be renamed by your build pipeline)
* App_Config\Include\zzzDeveloper\<Module Name>\xxx.config - configuration to make the developers environments run

## Deployment helpers

DeploymentValidation.ps1 - This publishes all of the source and ensures that the file names are all isolated. In many scenarios, this could be ran by the build server on a CI pipeline to ensure developers haven't broken this rule

CompleteDeploy.ps1 - This is for getting your development environment up to date - it performs a publish of everything thing the source using the Dev profile.

## Project Generation

There are powershell scripts in the Templates folder.

./Templates/Conduit/CreateProject.ps1 -ProjectFolder "MyNewFeature" -ProjectName "xxx.MyNewFeature"
./Templates/Module/CreateProject.ps1 -ProjectFolder "MyNewFeature" -ProjectName "xxx.MyNewFeature"

Once generated (in the outputs directory beneath the conduit / module folder), these need to be copied to their final destination and added to the solution file for that area.

## Conduits & Modules

Conduits are visual studio publishable projects that are publishable and provide content. Often they can be used as a way of bringing together functionality within a module or kernel group. They have key .csproj amends to allow them to be 

