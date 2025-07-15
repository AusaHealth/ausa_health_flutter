# Backend Models

This document lists the client-side (Flutter) data models so the backend can align request / response payloads.  
Unless stated otherwise **all fields are required** and should be sent in the same casing shown below.

---

## User
| Field | Type |
|-------|------|
| id | String |
| name | String |
| photoUrl | String |
| specialization | String |

## Test
| Field | Type | Notes |
|-------|------|------|
| type | TestType | bloodPressure, bloodOxygen, bloodGlucose, bodyTemperature, ecg, bodySound, ent |
| name | String | Display label |
| description | String | Short description |
| image | String | Asset / URL |
| result | String? | Text shown after completion |
| isDone | bool | Client-side progress flag |
| instructionType | TestInstructionType | video or text |
| videoInstructionSourcePath | String? | Video asset / URL |
| instructions | List<TestInstruction>? | Multi-step instructions (only if `instructionType` is text) |
| group | String? | Group identifier so related tests can be fetched together (replaces previous *categories*) |
| prerequisites | List<Prerequisite>? | Pre-check items to confirm before running the test |
| estimatedDurationSeconds | int? | For progress bar |
| usesAR | bool | Launches AR flow |
| selectedCategory | String? | UI helper |
| isSelected | bool | UI helper |

### Helper objects
* **TestInstruction** – `{ title : String, content : String, image : String }`
* **Prerequisite** – `{ id : String, question : String }`

## TestResult
| Field | Type |
|-------|------|
| id | String |
| testType | TestType |
| testName | String |
| completedAt | DateTime ISO-8601 |
| parameters | List<TestResultParameter> |
| overallStatus | TestResultStatus (normal, abnormal, pending, error) |
| notes | String? |
| category | String? |

### TestResultParameter
{ name : String, value : String, unit : String, isAbnormal : bool, normalRange? : String }

## VitalReading (base)
| Field | Type |
|-------|------|
| id | String |
| timestamp | DateTime |
| type | VitalType |
| status | VitalStatus |
| notes | String? |

Specialised vitals add extra fields:
* BloodPressureReading – systolic, diastolic, map, pulsePressure
* SpO2HeartRateReading – oxygenSaturation
* BloodGlucoseReading – glucoseLevel, measurementType
* BodyTemperatureReading – temperature, measurementLocation, temperatureUnit
* ECGReading – not sure

## MediaTestReading
| Field | Type |
|-------|------|
| id | String |
| timestamp | DateTime |
| type | MediaTestType (bodySound, ent) |
| status | MediaTestStatus (normal, abnormal, pending) |
| category | String |
| recordingPath | String? |
| duration | int? |
| notes | String? |
| parameters | List<MediaTestParameter> |
| findings | String? |

## Scheduling & Care Plan
* **HealthTimeSlot** – id, title, type, timeOfDay, mealTiming?, activities, isActive
* **HealthActivity** – id, title, type, isCompleted, subtitle?, targetRange?, dosage?, description?, condition?, completedAt?, metadata?, ctaText?, ctaIcon?
* **HealthCondition** – id, name, color, description?, isActive

## Appointments
* **Appointment** – id, dateTime, doctorName, doctorType, symptoms, status, doctorImageUrl?
* **TimeSlot (doctor availability)** – id, dateTime, isAvailable, doctorId?

## Settings
* **NetworkInfo** – name, isSecure, isConnected, signalStrength

> NOTE: Some fields exposed by the app (e.g. formatting helpers) are computed in the client and do **not** need to be supplied by the backend. 